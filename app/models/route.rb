class Route < ActiveRecord::Base
  belongs_to :map
  validates  :origin_point,       presence: true
  validates  :destination_point,  presence: true
  validates  :distance,           presence: true
end
