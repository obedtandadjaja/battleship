class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :password
      t.boolean :is_completed, default: false
      t.boolean :is_playing, default: false
      t.integer :num_players, null: false
      t.integer :type, default: 0

      t.timestamps null: false
    end
  end
end
