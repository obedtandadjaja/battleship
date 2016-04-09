class UsersController < ApplicationController

	def create_guest
		create_guest_user
		redirect_to '/'
	end

	def guest_sign_out
	    session[:user_id] = nil
	    self.current_user = nil
	end

end
