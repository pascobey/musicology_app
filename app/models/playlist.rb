class Playlist < ApplicationRecord
    belongs_to :library
    has_many :tracks
    has_many :artists, :through => :tracks
end
