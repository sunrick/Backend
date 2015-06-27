class Trip < ActiveRecord::Base
  has_many :places
  belongs_to :user
end
