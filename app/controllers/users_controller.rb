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
    saved_tracks_json = HTTParty.get(
      "#{SPOTIFY_API_URL}/v1/me/tracks",
      headers: {
        Authorization: "Bearer #{access_token_json['access_token']}"
      }
    )
    tracks = saved_tracks_json['items']
    i = 0
    until i >= saved_tracks_json['total']
      artists = []
      artists_hash = tracks[i]['track']['album']['artists']
      artists_hash.each do |ah|
        artists << Artist.create(library_id: @library_id, artist_name: ah['name'])
      end
      @track = Track.create(artist_name: artists.each.artist_name, track_name: tracks['track']['name'], album_name: tracks['track']['album']['name'])
      i = i.next
    end
    redirect_to(user_path(@user))
  end

end
