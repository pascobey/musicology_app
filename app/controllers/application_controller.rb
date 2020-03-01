class ApplicationController < ActionController::Base
    SPOTIFY_BASE_URL = 'https://accounts.spotify.com'.freeze
    SPOTIFY_AUTH_CODE_PATH = '/authorize'.freeze
    SPOTIFY_TOKEN_REQUEST_PATH = '/api/token'.freeze
    APP_LANDING_URL = 'https://floating-hamlet-63269.herokuapp.com/create'.freeze
    APP_LANDING_URI = URI.escape(APP_LANDING_URL, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")).freeze
    APP_CLIENT_ID = 'd7f2ddcb58784a428ff86348869cbfd9'.freeze
    APP_CLIENT_SECRET = '164b375ae4864c11a25810f923ebf9c8'.freeze
    CLIENT_B64 = Base64.encode64("#{APP_CLIENT_ID}:#{APP_CLIENT_SECRET}").freeze
    SCOPES = 'user-top-read user-follow-read user-library-read user-read-recently-played user-read-email'.freeze
    SCOPES_URI = URI.escape(SCOPES, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")).freeze
end
