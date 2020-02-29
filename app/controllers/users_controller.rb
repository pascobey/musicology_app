class UsersController < ApplicationController

  require 'httparty'

  @@app_landing = URI.escape('https://floating-hamlet-63269.herokuapp.com/create', Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  @@spotify_client_id = 'd7f2ddcb58784a428ff86348869cbfd9'
  @@scopes = 'user-top-read user-follow-read user-library-read user-read-recently-played user-read-email'
  # @request ="poop"

  def new
    @request = 'https://accounts.spotify.com/authorize' +
      '?client_id=' + @@spotify_client_id + '&response_type=code' +
      '&redirect_uri=' + @@app_landing +
      '&scope=' + URI.escape(@@scopes, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  def show
    # user_id = request.original_url.last(1)
    # user = User.where(id: user_id)
    # ac = user.auth_code
  end

  def create
    auth_code = request.original_url.last(352)
    # auth_code = "AQAWPSfcDXNTWOhnEDKoB9ny0_ee1NYSHpfNiOTJYzjAOUI2MbI39IwH39T2BYsegEnmiENpgvw7UKDqJnGqZEcSrLPHTPnIXKYKFqLpuu4Kn5gCL3cuGAD7Uwyc2OZBcqcKs5BNuuPFk2n6Acfth9Lu3td1ELzyqXHpKgRNHr7NEhjENhCDzqS0neMaCYlapJJXxLs_DALCPC2jLAPdDsBIqzRJcWTEPapXIw5_c0JtO9cRdt8uj90IsDvwFPxHDRrWqEOu7bzQOUo72bOW7pTRPerRy3Nf7md0VtIqgd8ZAPbNd9ZtOjHipekMDykieJNjsETY6liWeOsvUSfGE6amTzqIEU0v"
    access_token_json = HTTParty.post("https://accounts.spotify.com/api/token",
      body: { client_id: @spotify_client_id,
              client_secret: '164b375ae4864c11a25810f923ebf9c8',
              grant_type: 'authorization_code',
              code: auth_code,
              redirect_url: @app_landing
      },
      headers: { 'Authorization' => 'Basic'} )
    @user = User.create(auth_code: auth_code, access_token_json: access_token_json)
    redirect_to(user_path(@user))
  end

end
