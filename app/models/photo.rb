class Photo < ActiveRecord::Base
  validates :image_name, presence: true
  dragonfly_accessor :image
end
