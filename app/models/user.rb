class User < ApplicationRecord

    has_one :library

    def self.stratify_artist_representation_in_playlist(playlist_spotify_unique)
        temp_artists_array = []
        playlist = Playlist.find_by(spotify_unique: playlist_spotify_unique)
        playlist.tracks.each do |t|
            artists_names_array = []
            artists_names_string = t.artists_names
            if artists_names_string.include?("|")
                until artists_names_string.include?("|") == ""
                    if artists_names_string.include?("|")
                        artists_names_array << artists_names_string[0, artists_names_string.index("|")]
                        artists_names_string = artists_names_string.gsub("#{artists_names_string[0, (artists_names_string.index("|") + 1)]}", "")
                    else
                        artists_name_array << artists_names_string
                        artists_names_string = ""
                    end
                end
            else
                artists_names_array << artists_names_string
            end
            artists_names_array.each do |a|
                puts a
                # temp_artists_array << Artist.find_by(name: a).artist_spotify_unique
            end
        end
        counts = Hash.new(0)
        return temp_artists_array.each { |artist_spotify_unique| counts[artist_spotify_unique] += 1 }
    end

end
