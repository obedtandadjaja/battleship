class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :is_completed
      t.integer :num_players

      t.timestamps null: false
    end
  end
end
