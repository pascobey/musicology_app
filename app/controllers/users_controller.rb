class UsersController < ApplicationController

  def new
    @request = SPOTIFY_BASE_URL + SPOTIFY_AUTH_CODE_PATH +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end
  
  def show
  end

  def create
    auth_code = request.original_url.last(352)
    response = HTTParty.post(
      "#{SPOTIFY_BASE_URL}#{SPOTIFY_TOKEN_REQUEST_PATH}",
      multipart: true,
      headers: {
        Authorization: "Basic #{CLIENT_B64}"
      },
      body: {
        grant_type: "authorization_code",
        code: "#{auth_code}",
        redirect_uri: "#{APP_LANDING_URI}"
      }
    )


    @user = User.create(auth_code: auth_code, access_token_json: access_token_json)
    redirect_to(user_path(@user))

    # headers = {
    #   :authorization => 'Basic ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg='
    # }
    # access_token_json = RestClient.post 'https://accounts.spotify.com/api/token',
    #   {
    #     grant_type: "authorization_code",
    #     code: "#{auth_code}",
    #     redirect_uri: "#{@@app_landing}"
    #   }.to_json,
    #   headers

    # access_token_json = Faraday.new(
    #   'https://accounts.spotify.com/api/token',
    #   URI.encode_www_form(
    #     grant_type: "authorization_code",
    #     code: auth_code,
    #     redirect_uri: @@app_landing
    #   ),
    #   {
    #     'Authorization: Basic ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg='
    #   }
    # )
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
  end

end
