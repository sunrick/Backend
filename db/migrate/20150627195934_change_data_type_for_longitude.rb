class ChangeDataTypeForLongitude < ActiveRecord::Migration
  def self.up
    change_table :places do |t|
      t.change :longitude, :decimal
      t.change :latitude, :decimal
    end
  end
  def self.down
    change_table :tablename do |t|
      t.change :longitude, :integer
      t.change :latitude, :integer
    end
  end
end