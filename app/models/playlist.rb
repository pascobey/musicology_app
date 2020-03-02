class Playlist < ApplicationRecord
    belongs_to :library
    has many :tracks
end
