class TracksController < ApplicationController

  def create
    puts "tracks_controller create started!"
    puts access_token = request.original_url[(request.original_url.index("access_token=") + "access_token=".length), (request.original_url.index("&") - (request.original_url.index("access_token=") + "access_token=".length))]
    puts library_id = request.original_url.gsub("https://www.graphurmusic.com/building?access_token=#{access_token}&library_id=", "")
    playlists = Playlist.where(library_id: library_id)
    playlists.each do |p|
      playlist_tracks_json = HTTParty.get(
        "#{SPOTIFY_API_URL}/v1/playlists/#{p.spotify_unique}/tracks",
        headers: {
          Authorization: "Bearer #{access_token}"
        }
      )['items']
      if playlist_tracks_json
        playlist_tracks_json.each do |t|
          artists_names = ''
          artists_hash = t['track']['artists']
          artists_hash.each do |ah|
            if ah != artists_hash.first
              artists_names += '| '
            end
            if !Artist.find_by(artist_spotify_unique: ah['id'])
              puts "artist info not yet stored in db... requesting artist info... |test info below|"
              puts artist_json = HTTParty.get(
                "#{SPOTIFY_API_URL}/v1/artists/#{ah['id']}",
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
                Artist.create(artist_spotify_unique: artist_json['id'], name: artist_json['name'], spotify_open_url: spotify_open_url, follower_count: follower_count, genres: genres, artist_image_url: artist_image_url, spotify_popularity_index: artist_json['popularity'])
              end
            end
            artists_names += ah['name']
          end
          main_artist_name = artists_names
          if artists_names.include?("|")
            main_artist_name = artists_names[0, artists_names.index("|")]
          end
          main_artist_unique = Artist.find_by(name: main_artist_name).artist_spotify_unique
          Track.create(playlist_id: p.id, artist_spotify_unique: main_artist_unique, artists_names: artists_names, track_name: t['track']['name'], album_name: t['track']['album']['name'])      
        end
      end
    end
  end

  def show
  end

end
