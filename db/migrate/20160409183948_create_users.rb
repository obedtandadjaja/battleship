class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :games_played, default: 0
      t.integer :high_score, default: 0
      t.float :avg_score, default: 0
      t.integer :wins, default: 0
      t.integer :losses, default: 0
      t.integer :total_score, default: 0
      t.string :slug
      t.integer :current_channel, default: 0

      t.timestamps null: false
    end
  end
end
