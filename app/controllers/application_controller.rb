class ApplicationController < ActionController::Base
    SPOTIFY_BASE_URL = 'https://accounts.spotify.com'
    SPOTIFY_API_URL = 'https://api.spotify.com'
    APP_BASE_URL = 'https://graphurmusic.com'
    APP_LANDING_URL = "#{APP_BASE_URL}/create"
    APP_LANDING_URI = URI.escape(APP_LANDING_URL, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    APP_CLIENT_ID = 'd7f2ddcb58784a428ff86348869cbfd9'
    APP_CLIENT_SECRET = '164b375ae4864c11a25810f923ebf9c8'
    CLIENT_B64 = "ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg="
    SCOPES = 'user-top-read user-follow-read user-library-read user-read-recently-played user-read-email'
    SCOPES_URI = URI.escape(SCOPES, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
end
