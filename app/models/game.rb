class Game < ActiveRecord::Base

	validates :name, presence: true
	validates :type, presence: true
	validates :num_players, presence: true, numericality: {greater_than_or_equal_to: 2}
	validates :is_completed, default: false
	validates :is_playing, default: false
	validates :random, presence: true

	has_many :game_player, dependent: :destroy
	has_many :user, through: :game_player

	extend FriendlyId
  	friendly_id :random, use: :slugged

end
