class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :screen_name
      t.string :location
      t.string :description
      t.string :profile_image_url
      t.integer :followers_count
      t.integer :statuses_count
      t.integer :friends_count
      t.integer :listed_count
      t.date :account_creation

      t.timestamps null: false
    end
  end
end
