class StatusController < ApplicationController

  before_action :authorized?
  
  def build
    url_vars = retrieve_url_vars(request.original_url)
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
    @playlists = Playlist.where(library_id: @library_id)
    if url_vars[:playlist_id] == '1'
      @playlist_id = @playlists.first.id
    else
      @playlist_id = url_vars[:playlist_id]
      @playlist = @playlists.find_by(id: @playlist_id.to_i - 1)
      puts "status_build current_playlist - #{@playlist.name}"
      @artists = @playlist.artists
      puts "status_build current_playlist artists.size - #{@artists.size}"
    end
    if @playlists.find_by(id: @playlists.last.id).tracks == [] && @playlists.find_by(id: @playlists.last.id - 1).tracks == []
      @header = 'Retrieving Playlists Data'
    elsif @playlists.find_by(id: @playlists.first.id).tracks == []
      @header = 'Updating Playlists Data'
    else
      redirect_to(user_path(User.find_by(id: @library_id)))
    end
  end

end
