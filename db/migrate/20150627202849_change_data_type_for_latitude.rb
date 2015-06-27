class ChangeDataTypeForLatitude < ActiveRecord::Migration
  def self.up
    change_table :places do |t|
      t.change :longitude, :float
      t.change :latitude, :float
    end
  end
  def self.down
    change_table :tablename do |t|
      t.change :longitude, :decimal
      t.change :latitude, :decimal
    end
  end
end