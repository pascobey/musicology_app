class Playlist < ApplicationRecord

    belongs_to :library
    has_many :tracks

    def self.retrieve_playlists_json(spotify_api_url, access_token)
        playlists_json = HTTParty.get(
          "#{spotify_api_url}/v1/me/playlists",
          headers: {
            Authorization: "Bearer #{access_token}"
          }
        )['items']
        return playlists_json
    end
    
end
