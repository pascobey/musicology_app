class PlaylistsController < ApplicationController

  def create
    url_vars = retrieve_url_vars(request.original_url)
    playlists_json = Playlist.retrieve_playlists_json(SPOTIFY_API_URL, url_vars[:access_token])
    if playlists_json
      playlists_json.each do |p|
        if p['images']
          first_image_hash = p['images'].first
          if first_image_hash
            playlist_image_url = first_image_hash['url']
          end
          Playlist.create(library_id: url_vars[:library_id], spotify_unique: p['id'], playlist_image_url: playlist_image_url, name: p['name'])
        end
      end
    end
    redirect_to controller: 'status', action: 'build', library_id: url_vars[:library_id], access_token: url_vars[:access_token], playlist_id: "1", xt: '0'
  end

  def update
    url_vars = retrieve_url_vars(request.original_url)
    playlists_json = Playlist.retrieve_playlist_json(SPOTIFY_API_URL, url_vars[:access_token])
    if playlists_json  
      playlists_json.each do |p|
        if !Playlist.find_by(spotify_unique: p['id'])
          Playlist.create(library_id: url_vars[:library_id], spotify_unique: p['id'], name: p['name'])
        end
      end
    end
    redirect_to controller: 'status', action: 'finished', library_id: url_vars[:library_id], access_token: url_vars[:access_token], playlist_id: "1", xt: '0'
  end

end
