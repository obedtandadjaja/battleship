class PlayController < WebsocketRails::BaseController
before_filter :check_authentication

  	def initialize_session
    	# perform application setup here
    	controller_store[:message_count] = 0
  	end

  	def get_game
  		# Get channel and game from client
		channel = ActiveSupport::JSON.decode(message)["channel"]
		game_id = ActiveSupport::JSON.decode(message)["game_id"]

		puts "Redirect users to game"

		# Broadcast list of players to everyone in the lobby
		WebsocketRails[channel].trigger(:redirect_to_game, )
  	end

  	def guess
		@user = current_user || guest_user
		@game = Game.find(params[:game_id])
		if @user.game.include? @game
			@col = params[:col]
			@row = params[:row]
			@ship_cells = @game.ship.ship_cells
			@player = GamePlayer.where(game_id: @game.id, user_id: @user.id)
			@guesses = @player.guess
			@ship_cells.each do |cell|
				if cell.row == @row && cell.col == @col && cell.is_hit == false
					cell.update_attributes(is_hit: true)
					new_hits = {:ship_cells => @ship_cells.to_json, :guesses => @guesses}
					broadcast_message :update_board, new_hits
					return
				end
			end
			@guess = Guess.create(row: @row, col: @col, is_hit: true, game_player_id: @player.id)
			@player.guess << @guess
			new_hits = {:ship_cells => @ship_cells.to_json, :guesses => @guesses.to_json}
			broadcast_message :update_board, new_hits
		else
			flash[:notice] = "You have no permission!"
			redirect_to '/'
		end
	end
	
end