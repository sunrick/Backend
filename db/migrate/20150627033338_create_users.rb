class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.string :home_address
      t.string :password
      t.string :access_token

      t.timestamps null: false
    end
  end
end
