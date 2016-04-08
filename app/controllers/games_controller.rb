class GamesController < ApplicationController

	def show
		@game = Game.find(params[:id])
	end

	def guess
		@user = current_user
		@game = Game.find(params[:game_id])
		if @user.game.include? @game
			
		else
			respond_to do |format|
				format.json { render json: @user }
			end
		end
	end

end
