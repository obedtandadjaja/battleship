class HomeController < ApplicationController
	before_filter :check_authentication

	def check_authentication
		if !(current_user || guest_user)
			redirect_to '/users/sign_in'
		elsif guest_user
			flash[:notice] = "Signed in as a guest user"
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
