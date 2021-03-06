class GamesController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:guess]

	def in_game_lobby
		@game = Game.friendly.find(params[:id])
		@user = current_or_guest_user
		if !@game.user.include? @user
			if @game.user.count == @game.num_players
				flash[:alert] = "Sorry, unfortunately #{@game.name} is full."
				redirect_to '/'
			else
				# If this player is not already in the game. This is in case they are already added as master.
				unless GamePlayer.where(user_id: @user.id, game_id: @game.id).first
					# Add the player to the game
					GamePlayer.create(user_id: @user.id, game_id: @game.id, score: 0, is_master: false).save
				end
			end
		end
	rescue ActiveRecord::RecordNotFound
		flash[:alert] = "Game has been terminated."
		redirect_to '/'
	end

	def check
		Game.friendly.find(params[:id])
		respond_to do |format|
			format.json { render json: "true" }
		end
	rescue ActiveRecord::RecordNotFound
		respond_to do |format|
			format.json { render json: "false" }
		end
	end

	def get_ships
  		@user = User.find_by_slug(params[:user_slug])
  		@game = Game.friendly.find(params[:id])
  		@player = GamePlayer.where(game_id: @game.id, user_id: @user.id).first

  		@ship_cells = Array.new
  		@player.ship.each do |ship|
  			ship.ship_cell.each do |cell|
  				@ship_cells << [cell.column, cell.row, cell.is_hit]
  			end
  		end

  		respond_to do |format|
  			format.json { render json: @ship_cells }
  		end
  		
  	rescue ActiveRecord::RecordNotFound
  		flash[:alert] = "Game not found!"
		redirect_to '/'
  	end

  	def get_guesses
  		@user = User.find_by_slug(params[:user_slug])
  		@game = Game.friendly.find(params[:id])
  		@player = GamePlayer.where(game_id: @game.id, user_id: @user.id).first

  		@guess_cells = Array.new
  		@player.guess.each do |cell|
			@guess_cells << [cell.column, cell.row, cell.is_hit]
  		end

  		respond_to do |format|
  			format.json { render json: @guess_cells }
  		end
  		
  	rescue ActiveRecord::RecordNotFound
  		flash[:alert] = "Game not found!"
		redirect_to '/'
  	end

  	def get_scores
  		@user = current_or_guest_user
  		@game = Game.friendly.find(params[:id])
  		@players = GamePlayer.where(game_id: @game.id)
  		user_and_scores = Array.new
  		@players.each do |player|
  			if player.user_id == @user.id
  				user_and_scores << ["You", player.score]
  			else
  				user_and_scores << [User.find(player.user_id).name, player.score]
  			end
  		end
  		user_and_scores.sort_by { |x| x[1] }
  		render partial: "games/game_scores", :locals => {:array => user_and_scores}
  	end

	def show
		@user = current_or_guest_user
		@game = Game.friendly.find(params[:id])
		@player = GamePlayer.where(user_id: @user, game_id: @game.id).first
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
			WebsocketRails["gameindex"].trigger(:update)
		else
			flash[:alert] = @game.errors.full_messages
			redirect_to '/'
		end
	end

	def destroy
		Game.friendly.find(params[:id]).destroy
		WebsocketRails["gameindex"].trigger(:update)
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
