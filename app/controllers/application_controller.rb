class ApplicationController < ActionController::Base

    SPOTIFY_BASE_URL = 'https://accounts.spotify.com'
    SPOTIFY_API_URL = 'https://api.spotify.com'
    APP_BASE_URL = 'https://www.graphurmusic.com'
    APP_LANDING_URL = "#{APP_BASE_URL}/create"
    APP_LANDING_URI = URI.escape(APP_LANDING_URL, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    APP_CLIENT_ID = 'd7f2ddcb58784a428ff86348869cbfd9'
    APP_CLIENT_SECRET = '164b375ae4864c11a25810f923ebf9c8'
    CLIENT_B64 = "ZDdmMmRkY2I1ODc4NGE0MjhmZjg2MzQ4ODY5Y2JmZDk6MTY0YjM3NWFlNDg2NGMxMWEyNTgxMGY5MjNlYmY5Yzg="
    SCOPES = 'ugc-image-upload user-read-playback-state user-read-currently-playing streaming user-read-email playlist-read-collaborative playlist-read-private user-library-read user-top-read user-read-playback-position user-read-recently-played user-follow-read'
    SCOPES_URI = URI.escape(SCOPES, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    
    def retrieve_url_vars(url)
        access_token = url[(url.index("access_token=") + "access_token=".length), (url.index("&") - (url.index("access_token=") + "access_token=".length))]
        library_id = url[(url.index("library_id=") + "library_id=".length), (url.index("&") - (url.index("library_id=") + "library_id=".length))]
        if url.include?("playlist_id=")
            playlist_id = url[(url.index("playlist_id=") + "playlist_id=".length), (url.index("&") - (url.index("playlist_id=") + "playlist_id=".length))]
        else
            playlist_id = ''
        end
        return {:access_token => access_token, :library_id => library_id, :playlist_id => playlist_id}
    end
    
end
