class UsersController < ApplicationController

	def create_guest
		create_guest_user
		redirect_to '/'
	end

	def destroy_guest
		session[:guest_user_id] = nil
		redirect_to '/'
	end

end
