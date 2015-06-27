class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :address
      t.integer :longitude
      t.integer :latitude
      t.integer :trip_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
