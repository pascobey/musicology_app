class UsersController < ApplicationController

  def new
    if User.find_by(user_id: cookies[:user_id])
      flash[:notice] = "USER FOUND! Welcome Back, #{User.find_by(user_id: cookies[:user_id]).email}"
      redirect_to(user_path(User.find_by(user_id: cookies[:user_id])))
    end
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end

  def finished
    puts "started finished"
    url_vars = retreive_url_vars(request.original_url)
    if @user && !@user.library.playlist.find_by(id: @user.library.playlists.size).tracks
      puts "should redirect to finish_build"
      redirect_to controller: 'users', action: 'finish_build', library_id: url_vars[:library_id], access_token: url_vars[:access_token]
    else @user && !@user.library.playlist.find_by(id: 1).tracks
      puts "should redirect to finish_build"
      redirect_to controller: 'users', action: 'update_build', library_id: url_vars[:library_id], access_token: url_vars[:access_token]
    end
  end

  def finish_build
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
  end

  def update_build
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
    redirect_to controller: 'tracks', action: 'update', library_id: url_vars[:library_id], access_token: url_vars[:access_token]
  end

  def show
    @user = User.find_by(id: request.original_url[("#{APP_BASE_URL}/users/").size, 10000000000])
    if !@user || @user.user_id != cookies[:user_id]
      flash[:notice] = "Not permitted, please sign in."
      redirect_to('/')
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
      redirect_to controller: 'playlists', action: 'create', library_id: @library.id, access_token: access_token_json['access_token']
    else
      redirect_to controller: 'playlists', action: 'update', library_id: @library.id, access_token: access_token_json['access_token']
    end
  end

end
