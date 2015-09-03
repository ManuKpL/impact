class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.references :candidate, index: true, foreign_key: true
      t.string :data_type
      t.integer :average
      t.integer :percentage

      t.timestamps null: false
    end
  end
end
