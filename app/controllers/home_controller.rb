class HomeController < ApplicationController
	before_filter :check_authentication
	helper_method :current_or_guest_user

	def check_authentication
		if !current_or_guest_user
			redirect_to '/users/sign_in'
		end
	end

	def index
	end

	def highscore
	end

	def hall_of_fame
	end

	def users_online
	end

end
