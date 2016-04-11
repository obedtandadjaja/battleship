class Game < ActiveRecord::Base

	enum type: [:chaos, :traditional]
	validates :name, presence: true
	validates :type, presence: true
	validates :num_players, numericality: {greater_than_or_equal_to: 1}
	validates :is_completed, default: false
	validates :is_playing, default: false

end
