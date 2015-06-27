class Place < ActiveRecord::Base
  validates :address, presence: true
  validates :place_type, inclusion: { in: ["origin","waypoint","destination"] }

  belongs_to :trip
  belongs_to :user
end
