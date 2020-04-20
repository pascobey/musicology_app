class Track < ApplicationRecord

    belongs_to :playlist
    belongs_to :artist

    def self.retrieve_playlist_tracks_json(SPOTIFY_API_URL, access_token)
        playlist_tracks_json = HTTParty.get(
          "#{SPOTIFY_API_URL}/v1/playlists/#{p.spotify_unique}/tracks",
          headers: {
            Authorization: "Bearer #{access_token}"
          }
        )['items']
        return playlist_tracks_json
    end
    
end
