class GamesController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:guess]

	def in_game_lobby
		@game = Game.friendly.find(params[:id])
		@user = current_or_guest_user
		if @game.user.count == @game.num_players
			flash[:alert] = "Sorry, unfortunately #{@game.name} is full."
			redirect_to '/'
		else
			# If this player is not already in the game. This is in case they are already added as master.
			# unless GamePlayer.where(user_id: @user.id, game_id: @game.id).first
			# 	# Add the player to the game
			# 	GamePlayer.create(user_id: @user.id, game_id: @game.id, score: 0, is_master: false).save
			# end
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

	# def get_in_game_lobby_players
	# 	@game = Game.friendly.find(params[:id])
	# 	render partial: "games/in_game_lobby_players", :locals => {:players => @game.user}
	# end

	def invite
		@user = current_or_guest_user
		@game = Game.friendly.find(params[:id])
		GameMailer.invite_game(params[:email], @user, @game).deliver
		redirect_to :back
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
		@user = current_or_guest_user
		if @game.save
			GamePlayer.create(user_id: @user.id, game_id: @game.id, score: 0, is_master: true).save
			redirect_to "/games/in_game_lobby/#{@game.slug}"
			WebsocketRails["setupgameindex"].trigger(:update)
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
