class GamesController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:guess]

	def in_game_lobby
		@game = Game.friendly.find(params[:id])
		if @game.user.count == @game.num_players
			flash[:alert] = "Sorry, unfortunately #{@game.name} is full."
			redirect_to '/'
		end
	end

	def show
		@game = Game.friendly.find(params[:id])
		if @game.is_playing
			flash[:alert] = "Sorry, #{game.name} is no longer available. The game has started."
			redirect_to '/'
		elsif @game.user.count == @game.num_players
			flash[:alert] = "Sorry, unfortunately #{@game.name} is full."
			redirect_to '/'
		end
	end

	def get_chaos_games
		@chaos_games = Chaos.where(is_completed: false, is_playing: false)
		render partial: "home/lobby_games", :locals => {:games => @chaos_games}
	end

	def get_traditional_games
		@traditional_games = Traditional.where(is_completed: false, is_playing: false)
		render partial: "home/lobby_games", :locals => {:games => @traditional_games}
	end

	def get_in_game_lobby_players
		@game = Game.friendly.find(params[:id])
		render partial: "games/in_game_lobby_players", :locals => {:players => @game.user}
	end

	def new
		@game = Game.new
	end

	def authorize
		@game = Game.friendly.find(params[:id])
		if params[:game][:password] == @game.password
			redirect_to :action => 'in_game_lobby', :id => @game.slug
		else
			flash[:alert] = "Invalid Password!"
			redirect_to '/'
		end
	end

	def create
		require 'securerandom'
		random_string = SecureRandom.urlsafe_base64
		random_string2 = SecureRandom.urlsafe_base64
		@game = Game.create(num_players: params[:game][:num_players], name: params[:game][:name],
			password: params[:game][:password], type: params[:game][:type], channel: random_string,
			random: random_string2)
		if @game.save
			redirect_to "/games/in_game_lobby/#{@game.slug}"
		else
			flash[:alert] = @game.errors.full_messages
			redirect_to '/'
		end
	end

	def destroy
		Game.friendly.find(params[:id]).destroy
      	redirect_to '/games'
	end

	def edit
		@game = Game.friendly.find(params[:id])
	end

	def update
		@game = Game.friendly.find(params[:id])
	    if @game.update_attributes(num_players: params[:game][:num_players])
	      	redirect_to :action => 'show', :id => @game.slug
	  	else
	  		flash[:notice] = "The form you submitted is invalid."
			redirect_to :action => :edit, :id => @game.slug
	    end
	end

end
