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
    @user = User.create(auth_code: request.original_url.last(352))
    redirect_to(user_path(@user))
  end

end
