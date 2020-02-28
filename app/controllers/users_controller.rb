class UsersController < ApplicationController

  # appLanding = 'https://guarded-hollows-17803.herokuapp.com/'
  
  def new
    @spotify_data_request = 'https://accounts.spotify.com/authorize' +
      '?client_id=' + @@spotifyClientID + '&response_type=code' +
      '&redirect_uri=' +  URI.escape('https://floating-hamlet-63269.herokuapp.com/create', Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) +
      '&scope=' + URI.escape(@@scopes, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  def show
    # user_id = request.original_url.last(1)
    # user = User.where(id: user_id)
    # ac = user.auth_code
  end

  def create
    auth_code = request.original_url.last(352)
    # command = "curl -H “Authorization: Basic” -d client_id=d7f2ddcb58784a428ff86348869cbfd9 -d client_secret=164b375ae4864c11a25810f923ebf9c8 -d grant_type=authorization_code -d code="
    # + auth_code + "-d redirect_uri=https%3A%2F%2Ffloating-hamlet-63269.herokuapp.com%2Fcreate https://accounts.spotify.com/api/token > access_tokens.json"
    # system("echo", command)
    @user = User.create(auth_code: auth_code)
    redirect_to(user_path(@user))
  end

end
