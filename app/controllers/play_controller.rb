class PlayController < WebsocketRails::BaseController

  	def start_game
  		channel = ActiveSupport::JSON.decode(message)["channel"]
		game_id = ActiveSupport::JSON.decode(message)["game_id"]
		puts "Start game"

		@game = Game.find(game_id)
		@game.update_attributes(is_playing: true)

		@user = current_or_guest_user
		@user.update_attributes(current_channel: "ingame")

		@game.user.each do |user|
			user.update_attributes(current_channel: "ingame")
		end

		@user_ships = randomize_ship_cells(@game)
		puts @user_ships.to_json

		# Send redirect broadcast
  		WebsocketRails[channel].trigger(:playgame, @game.slug)
  	end

  	def randomize_ship_cells(game)
  		# Randomize two 2x1 ships
  		@game = game
  		@user_ships = Hash.new
  		@game_cells = Hash.new
  		# @game.user.each do |user|
  			@game_cells[1] = Array.new
  			2.times do
	  			while(true)
	  				ship_cell = random_ship
	  				if (!@game_cells.key? random_ship[0]) && (!@game_cells.key? random_ship[1])
	  					@game_cells[random_ship[0]] = true
	  					@game_cells[random_ship[1]] = true
	  					@game_cells[user.id].append random_ship[0]
	  					@game_cells[user.id].append random_ship[1]
	  					break
	  				end
	  			end
	  		end
  		# end

  		return @user_ships
  	end

  	def random_ship
  		# randomize first column
  		first_row = rand(65..75)
  		first_col = rand(1..10)

  		# second column must be a neighbor of the first column
  		random1 = rand(2) == 1
  		random2 = rand(2) == 1

  		if random1
  			# same column different row
  			second_col = first_col
  			second_row = -1
  			if random2
  				if(first_row-1 > 0)
	  				second_row = first_row-1
	  			elsif(first_row+1 < 11)
	  				second_row = first_row+1
	  			end
  			else
  				if(first_row+1 < 11)
	  				second_row = first_row+1
	  			elsif(first_row-1 > 0)
	  				second_row = first_row-1
	  			end
  			end
  		else
  			# same row different column
  			second_row = first_row
  			second_col = -1
  			if random2
  				if(first_col-1 > 0)
	  				second_col = first_col-1
	  			elsif(first_col+1 < 11)
	  				second_col = first_col+1
	  			end
  			else
  				if(first_col+1 < 11)
	  				second_col = first_col+1
	  			elsif(first_col-1 > 0)
	  				second_col = first_col-1
	  			end
  			end
  		end

  		return [[first_row, first_col], [second_row, second_col]]
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