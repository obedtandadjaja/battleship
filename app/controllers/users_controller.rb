class UsersController < ApplicationController

	def create_guest
		create_guest_user
		redirect_to '/'
	end

end
