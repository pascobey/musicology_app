class ApplicationController < ActionController::Base
    SPOTIFY_BASE_URL = 'https://accounts.spotify.com'.freeze
    SPOTIFY_API_URL = 'https://api.spotify.com'
    APP_BASE_URL = 'https://floating-hamlet-63269.herokuapp.com'
    APP_LANDING_URL = 'https://floating-hamlet-63269.herokuapp.com/create'.freeze
    APP_LANDING_URI = URI.escape(APP_LANDING_URL, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")).freeze
    APP_CLIENT_ID = 'd7f2ddcb58784a428ff86348869cbfd9'.freeze
    APP_CLIENT_SECRET = '164b375ae4864c11a25810f923ebf9c8'.freeze
    CLIENT_B64 = "ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg=".freeze
    SCOPES = 'user-top-read user-follow-read user-library-read user-read-recently-played user-read-email'.freeze
    SCOPES_URI = URI.escape(SCOPES, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")).freeze
end
