class Place < ActiveRecord::Base
  validates :address, presence: true

  belongs_to :trip
  belongs_to :user
end
