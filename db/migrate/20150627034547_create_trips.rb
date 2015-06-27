class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.integer :duration
      t.integer :distance
      t.string :user_id

      t.timestamps null: false
    end
  end
end
