class CreateGamePlayers < ActiveRecord::Migration
  def change
    create_table :game_players do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.boolean :is_master, default: false
      t.integer :score
      t.boolean :ships_left, default: true

      t.timestamps null: false
    end
  end
end
