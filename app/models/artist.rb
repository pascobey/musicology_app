class Artist < ApplicationRecord

    has_many :tracks

    def self.retrieve_artist_json(spotify_api_url, access_token)
        artist_json = HTTParty.get(
            "#{spotify_api_url}/v1/artists/#{ah['id']}",
            headers: {
              Authorization: "Bearer #{access_token}"
            }
          )
          if artist_json
            spotify_open_url = ''
            if artist_json['external_urls']
              external_urls = artist_json['external_urls']
              spotify_open_url = external_urls['spotify']
            end
            follower_count = ''
            if artist_json['followers']
              followers = artist_json['followers']
              follower_count = followers['total']
            end
            genres = ''
            if artist_json['genres']
              artist_json['genres'].each do |g|
                if genres == ''
                  genres = g
                else
                  genres = genres + ", #{g}"
                end
              end
            end
            artist_image_url = ''
            if artist_json['images']
              first_image_hash = artist_json['images'].first
              if first_image_hash
                artist_image_url = first_image_hash['url']
              end
            end
            artist_info = {:artist_spotify_unique => artist_json['id'], :name => artist_json['name'], :spotify_open_url => spotify_open_url, :follower_count => follower_count, :genres => genres, :artist_image_url => artist_image_url, :spotify_popularity_index => artist_json['popularity']}
            return artist_info
        end
    end

end
