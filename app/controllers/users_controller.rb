class UsersController < ApplicationController

  def new
    if User.find_by(user_id: cookies[:user_id])
      flash[:notice] = "USER FOUND! Welcome Back, #{User.find_by(user_id: cookies[:user_id]).email}"
      redirect_to(user_path(User.find_by(user_id: cookies[:user_id])))
    end
    puts "no user found by cookies[:user_id]..."
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end
  


  def show
    @user = User.find_by(id: request.original_url[("#{APP_BASE_URL}/users/").size, 100000000])
    if !@user || @user.user_id != cookies[:user_id]
      flash[:notice] = "Not permitted, please sign in."
      redirect_to('/')
    end
  end



  def create
    puts "create started! Spotify granted authorization code..."
    puts auth_code = request.original_url.last(352)
    puts "requesting access_token... |access_token_json below|"
    puts access_token_json = HTTParty.post(
      "#{SPOTIFY_BASE_URL}/api/token",
      body: "grant_type=authorization_code&code=#{auth_code}&redirect_uri=#{APP_LANDING_URI}",
      headers: {
        Authorization: "Basic #{CLIENT_B64}"
      }
    )
    puts "requesting user profile... |user_profile_json below|"
    puts user_profile_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    puts "see if user exists..."
    if !User.find_by(user_id: user_profile_json['id'])
      puts "user doesn't exist, creating user... |@user object below|"
      puts @user = User.create(user_id: user_profile_json['id'], email: user_profile_json['email'], account_url: user_profile_json.dig('external_urls', 'spotify'), refresh_token: access_token_json['refresh_token'])
      puts "creating library... |@library object below|"
      puts @library = Library.create(user_id: @user.id)
      puts "requesting user playlists... |playlists_json below|"
      puts playlists_json = HTTParty.get(
        "#{SPOTIFY_API_URL}/v1/me/playlists",
        headers: {
          Authorization: "Bearer #{access_token_json['access_token']}"
        }
      )
      puts "creating playlists..."
      playlists_json['items'].each do |p|
        Playlist.create(library_id: @library.id, spotify_unique: p['id'], name: p['name'])
      end
      playlists = Playlist.where(library_id: @library.id)
      playlists.each do |p|
        puts "requesting tracks in playlist... |playlist_tracks_json below|"
        puts playlist_tracks_json = HTTParty.get(
          "#{SPOTIFY_API_URL}/v1/playlists/#{p.spotify_unique}/tracks",
          headers: {
            Authorization: "Bearer #{access_token_json['access_token']}"
          }
        )['items']
        playlist_tracks_json.each do |t|
          artists_names = ''
          artists_hash = t['track']['artists']
          artists_hash.each do |ah|
            puts "|artist hash for a track below|"
            puts ah
            if ah != artists_hash.first
              artists_names += ', '
            end
            if !Artist.find_by(library_id: @library.id, name: ah['name'])
              puts "requesting artist info... |artist_json below|"
              puts artist_json = HTTParty.get(
                "#{SPOTIFY_API_URL}/v1/artists/#{ah['id']}",
                headers: {
                  Authorization: "Bearer #{access_token_json['access_token']}"
                }
              )
              # Artist.create(artist_spotify_unique: , library_id: @library.id, name: ah['name'], :spotify_open_url , :spotify_api_url , :follower_count , :genres , :artist_image_url , :spotify_popularity_index )
            end
            artists_names += ah['name']
          end
          puts "create track... |track object below|"
          Track.create(playlist_id: p.id, artists_names: artists_names, track_name: t['track']['name'], album_name: t['track']['album']['name'])      
        end
      end
      cookies.permanent[:user_id] = @user.user_id
    else
      # UPDATE INFORMATION
    end
    redirect_to(user_path(@user))
  end


  
end
