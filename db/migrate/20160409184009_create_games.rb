class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :password
      t.string :channel, null: false
      t.boolean :is_completed, default: false
      t.boolean :is_playing, default: false
      t.integer :num_players, null: false
      t.string :type, null: false, default: "Chaos"

      t.timestamps null: false
    end
  end
end
