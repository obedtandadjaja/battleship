class Game < ActiveRecord::Base

	validates :name, presence: true
	validates :type, presence: true
	validates :num_players, numericality: {greater_than_or_equal_to: 1}
	validates :is_completed, default: false
	validates :is_playing, default: false

	has_many :game_player, dependent: :destroy
	has_many :user, through: :game_player

end
