class HomeController < ApplicationController
	before_filter :check_authentication

	def check_authentication
		if !(current_user || guest_user)
			redirect_to '/users/sign_in'
		end
	end

	def index
		@games = Game.where(is_completed: false, is_playing: false)
	end

	def highscore
	end

	def hall_of_fame
	end

	def users_online
	end

end
