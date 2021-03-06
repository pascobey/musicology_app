class UsersController < ApplicationController


  def new
    if User.find_by(user_spotify_unique: cookies[:user_id])
      @user = User.find_by(user_spotify_unique: cookies[:user_id])
      flash[:notice] = "USER FOUND! Welcome Back, #{@user.email}"
      redirect_to controller: 'playlists', action: 'update', library_id: @user.id, access_token: @user.refresh_token, xt: '0'
    end
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end

  def show
    if !User.find_by(id: request.original_url.gsub("#{APP_BASE_URL}/users/", ""))
      puts "User nil"
      flash[:notice] = "Not permitted, please sign in."
      redirect_to('/')
      return
    end
    puts "you belong here..."
    @user = User.find_by(id: request.original_url.gsub("#{APP_BASE_URL}/users/", ""))
    @playlists = Library.find_by(user_id: @user.id).playlists
    @playlists_stratifications = []
    @artists = []
    @playlists.each do |p|
      @playlists_stratifications << User.stratify_artist_representation_in_playlist(p.spotify_unique)
      @artists << p.artists
    end
    @artists = @artists.uniq.flatten
    @library_stratified = @playlists_stratifications.inject{ |artist_spotify_unique, pr| artist_spotify_unique.merge( pr ){ |k, pr, lr| pr + lr } }.sort_by{ |k,v| v }.to_a.reverse.to_h
    # puts "@ artists_spotify_uniques #{@artists_spotify_unique = @library_stratified.select{|k,v| v == 7}.keys}"
  end

  def create
    auth_code = request.original_url.gsub("https://www.graphurmusic.com/create?code=", "")
    access_token_json = HTTParty.post(
      "#{SPOTIFY_BASE_URL}/api/token",
      body: "grant_type=authorization_code&code=#{auth_code}&redirect_uri=#{APP_LANDING_URI}",
      headers: {
        Authorization: "Basic #{CLIENT_B64}"
      }
    )
    user_profile_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    if !User.find_by(user_spotify_unique: user_profile_json['id'])
      @user = User.create(user_spotify_unique: user_profile_json['id'], email: user_profile_json['email'], account_url: user_profile_json.dig('external_urls', 'spotify'), refresh_token: access_token_json['refresh_token'])
      @library = Library.create(user_id: @user.id)
      cookies.permanent[:user_id] = @user.user_spotify_unique
      redirect_to controller: 'playlists', action: 'create', library_id: @library.id, access_token: access_token_json['access_token'], xt: '0'
    else
      @user = User.find_by(user_spotify_unique: user_profile_json['id'])
      cookies.permanent[:user_id] = @user.user_spotify_unique
      redirect_to controller: 'playlists', action: 'update', library_id: @user.id, access_token: @user.refresh_token, xt: '0'
    end
  end
  
  def end
    cookies[:user_id] = ''
    redirect_to('/')
  end

end
