class UsersController < ApplicationController

  def new
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
    
    puts playlists_json['items']
    i = 0
    while i < saved_tracks_json['total']
      artist_hashes = tracks.dig(i, 'track')['album']['artists']
      track_artists = ''
      artist_hashes.each do |ah|
        if  !Artist.find_by(name: ah['name'])
          if ah != artist_hashes.first
            track_artists += ' '
          end
          artist = Artist.create(library_id: @library_id, name: ah['name'])
          track_artists += artist.name
        end
      end
      @track = Track.create(artists: track_artists, track_name: tracks.dig(i, 'track')['name'], album_name: tracks.dig(i, 'track')['album']['name'])
      i = i.next
    end
    redirect_to(user_path(@user))
  end

end
