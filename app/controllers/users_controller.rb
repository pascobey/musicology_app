class UsersController < ApplicationController

  @@app_landing = URI.escape('https://floating-hamlet-63269.herokuapp.com/create', Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  @@spotify_client_id = 'd7f2ddcb58784a428ff86348869cbfd9'
  @@spotify_client_secret = '164b375ae4864c11a25810f923ebf9c8'
  @@scopes = 'user-top-read user-follow-read user-library-read user-read-recently-played user-read-email'

  def new
    @request = 'https://accounts.spotify.com/authorize' +
      '?client_id=' + @@spotify_client_id + '&response_type=code' +
      '&redirect_uri=' + @@app_landing +
      '&scope=' + URI.escape(@@scopes, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
  
  def show
  end

  def create
    auth_code = request.original_url.last(352)
    access_token_json = Faraday.new(
      'https://accounts.spotify.com/api/token',
      URI.encode_www_form(
        grant_type: "authorization_code",
        code: auth_code,
        redirect_uri: @@app_landing
      ),
      {
        'Authorization: Basic ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg='
      }
    )
    # access_token_json = Faraday.post(
    #   'https://accounts.spotify.com/api/token',
    #   URI.encode_www_form(
    #     client_id: @@spotify_client_id,
    #     client_secret: @@spotify_client_secret,
    #     grant_type: 'authorization_code',
    #     code: auth_code,
    #     redirect_uri: @@app_landing
    #   )
    # )
    @user = User.create(auth_code: auth_code, access_token_json: access_token_json)
    redirect_to(user_path(@user))
  end

end
