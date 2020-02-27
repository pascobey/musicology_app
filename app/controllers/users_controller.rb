class UsersController < ApplicationController

  # spotifyClientID = 'd7f2ddcb58784a428ff86348869cbfd9'
  # appLanding = 'https://guarded-hollows-17803.herokuapp.com/'
  scopes = ['user-top-read', 'user-follow-read', 'user-library-read', 'user-read-recently-played', 'user-read-email']
  
  def new
    
    @spotify_data_request = 'https://accounts.spotify.com/authorize' +
      '?client_id=' + 'd7f2ddcb58784a428ff86348869cbfd9' + '&response_type=code' +
      '&redirect_uri=' +  URI.escape('https://guarded-hollows-17803.herokuapp.com/thanks', Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) +
      '&scope=' + URI.escape('user-top-read user-follow-read user-library-read user-read-recently-played user-read-email',
        Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  def show
    @auth_code = request.original_url
  end

  # def create
  # end

  # def edit
  # end

  # def update
  # end

  # def delete
  # end

  # def destroy
  # end

end
