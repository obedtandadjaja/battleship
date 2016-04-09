class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.references :game_player, index: true, foreign_key: true
      t.string :row
      t.string :column
      t.boolean :is_hit

      t.timestamps null: false
    end
  end
end
