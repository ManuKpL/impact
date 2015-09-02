class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.references :topword, index: true, foreign_key: true
      t.string :content
      t.integer :count

      t.timestamps null: false
    end
  end
end
