class Library < ApplicationRecord
    belongs_to :user
    has_many :playlists
    has_many :artists
end
