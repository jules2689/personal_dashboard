class TopTrack < ActiveRecord::Base
  has_many :images
  has_and_belongs_to_many :top_tags
  has_one :streamable
  belongs_to :artist
end
