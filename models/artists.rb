class Artist < ActiveRecord::Base
  has_many :top_tracks
end
