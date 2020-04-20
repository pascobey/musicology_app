class Playlist < ApplicationRecord

    belongs_to :library
    has_many :tracks

    def self.retrieve_playlists_json(SPOTIFY_API_URL, access_token)
        playlists_json = HTTParty.get(
          "#{SPOTIFY_API_URL}/v1/me/playlists",
          headers: {
            Authorization: "Bearer #{access_token}"
          }
        )['items']
        return playlists_json
    end
    
end
