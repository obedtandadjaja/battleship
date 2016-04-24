class Ship < ActiveRecord::Base
  belongs_to :game_player
  has_many :ship_cell
end
