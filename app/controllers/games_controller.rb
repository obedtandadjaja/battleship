class GamesController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:guess]

	def in_game_lobby
		@game = Game.find(params[:id])
	end

	def show
		@game = Game.find(params[:id])
	end

	def new
		@game = Game.new
	end

	def create
		require 'securerandom'
		random_string = SecureRandom.base64
		@game = Game.create(num_players: params[:game][:num_players], name: params[:game][:name],
			password: params[:game][:password], type: params[:game][:type], channel: random_string)
		if @game.save
			redirect_to "/games/in_game_lobby/#{@game.id}"
		else
			flash[:alert] = @game.errors.full_messages
			redirect_to '/'
		end
	end

	def destroy
		Game.find(params[:id]).destroy
      	redirect_to '/games'
	end

	def edit
		@game = Game.find(params[:id])
	end

	def update
		@game = Game.find(params[:id])
	    if @game.update_attributes(num_players: params[:game][:num_players])
	      	redirect_to :action => 'show', :id => @game
	  	else
	  		flash[:notice] = "The form you submitted is invalid."
			redirect_to :action => :edit, :id => @game
	    end
	end

end
