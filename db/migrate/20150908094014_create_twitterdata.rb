class CreateTwitterdata < ActiveRecord::Migration
  def change
    create_table :twitterdata do |t|
      t.references :candidate, index: true, foreign_key: true
      t.string :id_twitter
      t.string :data_type
      t.binary :data

      t.timestamps null: false
    end
  end
end
