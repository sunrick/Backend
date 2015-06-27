class Place < ActiveRecord::Base
  validates :address, presence: true
  validates :place_type, :inclusion => { :in => %w(origin destination waypoint), :message => "%not a valid option" }

  belongs_to :trip
  belongs_to :user
end
