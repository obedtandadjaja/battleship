class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.references :game_player, index: true, foreign_key: true
      t.boolean :is_sunk

      t.timestamps null: false
    end
  end
end
