class StatusController < ApplicationController

  def finished
    puts "started finished"
    url_vars = retrieve_url_vars(request.original_url)
    library = Library.find_by(id: url_vars[:library_id])
    if !library.playlist.find_by(id: library.playlists.size).tracks
      puts "should redirect to finish_build"
      redirect_to controller: 'status', action: 'finish_build', library_id: url_vars[:library_id], access_token: url_vars[:access_token]
    else library.playlist.find_by(id: 1).tracks
      puts "should redirect to update_build"
      redirect_to controller: 'status', action: 'update_build', library_id: url_vars[:library_id], access_token: url_vars[:access_token]
    end
  end

  def finish_build
    puts "started finish_build"
    url_vars = retrieve_url_vars(request.original_url)
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
  end

  def update_build
    puts "started update_build"
    url_vars = retrieve_url_vars(request.original_url)
    @library_id = url_vars[:library_id]
    @access_token = url_vars[:access_token]
  end

end
