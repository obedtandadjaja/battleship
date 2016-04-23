class HomeController < ApplicationController
before_filter :check_authentication

	def index
		@chaos_games = Chaos.where(is_completed: false, is_playing: false)
		@traditional_games = Traditional.where(is_completed: false, is_playing: false)
	end

	def highscore
	end

	def hall_of_fame
	end

	def users_online
	end

end
