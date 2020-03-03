class UsersController < ApplicationController

  def new
    if cookies[:user_id]
      redirect_to(user_path(@user.find_by(user_id: cookies[:user_id])))
    end
    @request = SPOTIFY_BASE_URL + '/authorize' +
      '?client_id=' + APP_CLIENT_ID + '&response_type=code' +
      '&redirect_uri=' + APP_LANDING_URI +
      '&scope=' + SCOPES_URI
  end
  
  def show
    @user = User.find_by(id: request.original_url[("#{APP_BASE_URL}/users/").size, 100000000])
  end

  def create
    auth_code = request.original_url.last(352)
    access_token_json = HTTParty.post(
      "#{SPOTIFY_BASE_URL}/api/token",
      body: "grant_type=authorization_code&code=#{auth_code}&redirect_uri=#{APP_LANDING_URI}",
      headers: {
        Authorization: "Basic #{CLIENT_B64}"
      }
    )
    user_profile_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    @user = User.create(user_id: user_profile_json['id'], email: user_profile_json['email'],
      account_url: user_profile_json.dig('external_urls', 'spotify'), refresh_token: access_token_json['refresh_token'])
    @library = Library.create(user_id: @user.id)
    playlists_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me/playlists",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    playlists_json['items'].each do |p|
      Playlist.create(library_id: @library.id, spotify_unique: p['id'], name: p['name'])
    end
    playlists = Playlist.where(library_id: @library.id)
    playlists.each do |p|
      playlist_tracks_json = HTTParty.get(
        "#{SPOTIFY_API_URL}/v1/playlists/#{p.spotify_unique}/tracks",
        headers: {
          Authorization: "Bearer #{access_token_json['access_token']}"
        }
      )['items']
      playlist_tracks_json.each do |t|
        artists_names = ''
        artists_hash = t['track']['artists']
        artists_hash.each do |ah|
          if ah != artists_hash.first
            artists_names += ', '
          end
          if !Artist.find_by(name: ah['name'])
            Artist.create(name: ah['name'])
          end
          artists_names += ah['name']
        end
        Track.create(playlist_id: p.id, artists_names: artists_names, track_name: t['track']['name'], album_name: t['track']['album']['name'])      
      end
    end
    cookies.permanent[:user_id] = @user.user_id
    redirect_to(user_path(@user))
  end

end
