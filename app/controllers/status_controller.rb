class StatusController < ApplicationController

  before_action :authorized?
  
  def build
    url_vars = retrieve_url_vars(request.original_url)
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
    @playlists = Playlist.where(library_id: @library_id)
    @playlist_id = url_vars[:playlist_id]
    # Conditional checks if every playlist empty or are there new playlists?
    if @playlists.find_by(id: @playlists.size).tracks == []
      @header = 'Retrieving Playlists Data'
    elsif @playlists.find_by(id: 1).tracks == []
      @header = 'Updating Playlists Data'
    else
      redirect_to(user_path(User.find_by(id: @library_id)))
    end
  end

end
