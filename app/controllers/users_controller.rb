class UsersController < ApplicationController

	def create_guest
		create_guest_user
		redirect_to '/'
	end

	def destroy_guest
		session[:guest_user_id] = nil
		redirect_to '/'
	end

	def show
		@user = User.friendly.find(params[:id])
	end

	def edit
		@user = User.friendly.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(name: params[:user][:name], email: params[:user][:email])
			redirect_to action: :show, id: @user.slug
		else
			flash[:alert] = @user.errors.full_messages
			redirect_to action: :edit, id: @user.slug
		end
	end

end
