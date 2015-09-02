class CreateTopwords < ActiveRecord::Migration
  def change
    create_table :topwords do |t|
      t.references :candidate, index: true, foreign_key: true
      t.string :type

      t.timestamps null: false
    end
  end
end
