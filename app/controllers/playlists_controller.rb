class PlaylistsController < ApplicationController

  def create
    access_token = request.original_url[(request.original_url.index("access_token=") + "access_token=".length), (request.original_url.index("&") - (request.original_url.index("access_token=") + "access_token=".length))]
    library_id = request.original_url.gsub("https://www.graphurmusic.com/building?access_token=#{access_token}&library_id=", "")
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
