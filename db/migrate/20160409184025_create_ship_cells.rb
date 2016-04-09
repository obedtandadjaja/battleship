class CreateShipCells < ActiveRecord::Migration
  def change
    create_table :ship_cells do |t|
      t.references :ship, index: true, foreign_key: true
      t.string :row
      t.string :column
      t.boolean :is_hit

      t.timestamps null: false
    end
  end
end
