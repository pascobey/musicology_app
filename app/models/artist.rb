class Artist < ApplicationRecord
    belongs_to :library
    has_many :tracks
end
