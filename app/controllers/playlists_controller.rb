class PlaylistsController < ApplicationController

  def create
    puts "playlists_controller create started!"
    puts url = request.original_url
    puts access_token = url[(url.index("access_token=") + "access_token=".length), (url.index("&") - (url.index("access_token=") + "access_token=".length))]
    puts library_id = url[(url.length - 1), 1]
    playlists_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me/playlists",
      headers: {
        Authorization: "Bearer #{access_token}"
      }
    )['items']
    playlists_json.each do |p|
      Playlist.create(library_id: library_id, spotify_unique: p['id'], name: p['name'])
    end
    redirect_to controller: 'tracks', action: 'create', library_id: library_id, access_token: access_token
  end

  def show
  end

end
