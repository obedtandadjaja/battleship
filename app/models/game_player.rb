class GamePlayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :ship
  has_many :guess
end
