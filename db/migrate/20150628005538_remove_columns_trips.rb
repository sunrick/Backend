class RemoveColumnsTrips < ActiveRecord::Migration
  def self.up
    remove_column :trips, :duration
    remove_column :trips, :distance
  end
  
  def self.down
    add_column :trips, :duration, :integer
    add_column :trips, :distance, :integer
  end
end
