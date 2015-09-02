class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :screen_name
      t.string :description
      t.integer :followers_count
      t.integer :following_count
      t.integer :listed
      t.integer :tweets_count
      t.date :account_creation
      t.string :picture

      t.timestamps null: false
    end
  end
end
