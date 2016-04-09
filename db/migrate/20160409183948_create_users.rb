class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :games_played
      t.integer :high_score
      t.float :avg_score
      t.integer :wins
      t.integer :losses
      t.integer :total_score

      t.timestamps null: false
    end
  end
end
