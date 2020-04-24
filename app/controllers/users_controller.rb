class UsersController < ApplicationController


  def new
    if User.find_by(user_id: cookies[:user_id])
      flash[:notice] = "USER FOUND! Welcome Back, #{User.find_by(user_id: cookies[:user_id]).email}"
      redirect_to controller: 'playlists', action: 'update', library_id: @library.id, access_token: access_token_json['access_token']
    end
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end

  def show
    @user = User.find_by(id: request.original_url.gsub("#{APP_BASE_URL}/users/", ""))
    # if !@user
    #   flash[:notice] = "Not permitted, please sign in."
    #   redirect_to('/')
    # else @user.user_id != cookies[:user_id]
    #   redirect_to(user_path(User.find_by(user_id: cookies[:user_id]).id))
    # end
    @playlists = Library.find_by(user_id: request.original_url.gsub("#{APP_BASE_URL}/users/", "")).playlists
    @playlists_stratifications = []
    @playlists.each do |p|
      puts p.id
      @playlists_stratifications << User.stratify_artist_representation_in_playlist(p.spotify_unique)
    end
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
    if !User.find_by(user_id: user_profile_json['id'])
      @user = User.create(user_id: user_profile_json['id'], email: user_profile_json['email'], account_url: user_profile_json.dig('external_urls', 'spotify'), refresh_token: access_token_json['refresh_token'])
      @library = Library.create(user_id: @user.id)
      cookies.permanent[:user_id] = @user.user_id
      redirect_to controller: 'playlists', action: 'create', library_id: @library.id, access_token: access_token_json['access_token'], xt: '0'
    else
      redirect_to controller: 'playlists', action: 'update', library_id: @library.id, access_token: access_token_json['access_token'], xt: '0'
    end
  end

end
