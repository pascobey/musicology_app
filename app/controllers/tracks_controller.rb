class TracksController < ApplicationController

  def create
    url_vars = retrieve_url_vars(request.original_url)
    playlists = Playlist.where(library_id: url_vars[:library_id])
    playlists.each do |p|
      playlist_tracks_json = Track.retrieve_playlist_tracks_json(SPOTIFY_API_URL, url_vars[:access_token], p.spotify_unique)
      if playlist_tracks_json
        playlist_tracks_json.each do |t|
          artists_names = ''
          artists_hash = t['track']['artists']
          artists_hash.each do |ah|
            if ah != artists_hash.first
              artists_names += '| '
            end
            if !Artist.find_by(artist_spotify_unique: ah['id'])
              puts artist_info = Artist.retrieve_artist_json(SPOTIFY_API_URL, url_vars[:access_token], ah['id'])
              if artist_info[:artist_spotify_unique]
                Artist.create(artist_spotify_unique: artist_info[:artist_spotify_unique], name: artist_info[:name], spotify_open_url: artist_info[:spotify_open_url], follower_count: artist_info[:follower_count], genres: artist_info[:genres], artist_image_url: artist_info[:artist_image_url], spotify_popularity_index: artist_info[:spotify_popularity_index])
              else
                Artist.create(artist_spotify_unique: ah['id'], name: ah['name'], spotify_open_url: "N/A (PODCAST)", follower_count: "N/A (PODCAST)", genres: "N/A (PODCAST)", artist_image_url: "N/A (PODCAST)", spotify_popularity_index: "N/A (PODCAST)")
              end
            end
            artists_names += ah['name']
          end
          main_artist_name = artists_names
          if artists_names.include?("|")
            main_artist_name = artists_names[0, artists_names.index("|")]
          end
          Track.create(playlist_id: p.id, artist_id: Artist.find_by(name: main_artist_name).id, artist_spotify_unique: Artist.find_by(name: main_artist_name).artist_spotify_unique, artists_names: artists_names, track_name: t['track']['name'], track_spotify_unique: t['track']['id'], album_name: t['track']['album']['name'])
        end
      end
      sleep 1
    end
    redirect_to(user_path(User.find_by(id: cookies[:user_id])))
  end

  def update
    url_vars = retrieve_url_vars(request.original_url)
    playlists = Playlist.where(library_id: url_vars[:library_id])
    playlists.each do |p|
      playlist_tracks_json = Track.retrieve_playlist_tracks_json(SPOTIFY_API_URL, url_vars[:access_token], p.spotify_unique)
      if !playlist_tracks_json
        Playlist.find_by(playlist_id: p.id).destroy
      else
        playlist_tracks_json.each do |t|
          if !Track.find_by(track_spotify_unique: t['track']['id'])
            artists_names = ''
            artists_hash = t['track']['artists']
            artists_hash.each do |ah|
            if ah != artists_hash.first
              artists_names += '| '
            end
            if !Artist.find_by(artist_spotify_unique: ah['id'])
              artist_info = Artist.retrieve_artist_json(SPOTIFY_API_URL, url_vars[:access_token], ah['id'])
              Artist.create(artist_spotify_unique: artist_info[:artist_spotify_unique], name: artist_info[:name], spotify_open_url: artist_info[:spotify_open_url], follower_count: artist_info[:follower_count], genres: artist_info[:genres], artist_image_url: artist_info[:artist_image_url], spotify_popularity_index: artist_info[:spotify_popularity_index])
            end
            artists_names += ah['name']
          end
          main_artist_name = artists_names
          if artists_names.include?("|")
            main_artist_name = artists_names[0, artists_names.index("|")]
          end
          Track.create(playlist_id: p.id, artist_id: Artist.find_by(name: main_artist_name).id, artist_spotify_unique: Artist.find_by(name: main_artist_name).artist_spotify_unique, artists_names: artists_names, track_name: t['track']['name'], track_spotify_unique: t['track']['id'], album_name: t['track']['album']['name'])
          end
        end
      end
    end
    redirect_to(user_path(User.find_by(id: cookies[:user_id])))
  end

end
