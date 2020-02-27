class UsersController < ApplicationController

  def new
    spotifyClientID = 'd7f2ddcb58784a428ff86348869cbfd9'
    @spotify_data_request = 'https://accounts.spotify.com/authorize' +
      '&client_id=' + spotifyClientID + '?response_type=code' +
      '&redirect_uri=' + URI.encode_www_form_component(@appLanding) +
      '&scope=' + URI.encode_www_form_component(@scopes)
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
