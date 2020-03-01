class UsersController < ApplicationController

  def new
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end
  
  def show
    # WILL BREAK!!!!!
    @user = User.find_by(id: request.original_url.last(1))
  end

  def create
    auth_code = request.original_url.last(352)
    access_token_json = HTTParty.post(
      "#{SPOTIFY_BASE_URL}/api/token",
      body: "grant_type=authorization_code&code=#{auth_code}&redirect_uri=#{APP_LANDING_URI}",
      headers: {
        Authorization: "Basic #{CLIENT_B64}"
      }
    )
    puts access_token_json
    user_profile_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    @user = User.create(user_id: user_profile_json['id'], email: user_profile_json['email'],
      account_url: user_profile_json.dig('external_urls', 'spotify'), refresh_token: access_token_json['refresh_token'])
    # @user = User.create(user_profile_json: user_profile_json, refresh_token: access_token_json['refresh_token'])
    redirect_to(user_path(@user))
  end

end
