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
		puts @user_ships
		@user_ships.each do |key, value|
			@player = GamePlayer.where(game_id: game_id, user_id: key).first
			value.each do |i|
				ship = Ship.create(game_player_id: @player.id, is_sunk: false)
				i.each do |x|
					ShipCell.create(ship_id: ship.id, row: x[0], column: x[1], is_hit: false)
				end
			end
		end

		# Send redirect broadcast
  		WebsocketRails[channel].trigger(:playgame, @game.slug)
  	end

  	def randomize_ship_cells(game)
  		# Randomize two 2x1 ships
  		@game = game
  		@user_ships = Hash.new
  		@game_cells = Hash.new
  		@game.user.each do |user|
  			@user_ships[user.id] = Array.new
  			2.times do |i|
  				@user_ships[user.id][i] = Array.new
	  			while(true)
	  				ship_cell = random_ship
	  				if (!@game_cells.key? ship_cell[0]) && (!@game_cells.key? ship_cell[1])
	  					@game_cells[ship_cell[0]] = true
	  					@game_cells[ship_cell[1]] = true
	  					@user_ships[user.id][i] << ship_cell[0]
	  					@user_ships[user.id][i] << ship_cell[1]
	  					break
	  				end
	  			end
	  		end
  		end

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

  		return [[first_row.chr, first_col], [second_row.chr, second_col]]
  	end

  	def get_ships
  		@user = current_or_guest_user
  		@game = Game.friendly.find(params[:id])
  		@player = GamePlayer.where(game_id: @game.id, user_id: @user.id).first

  		@ship_cells = Array.new;
  		@player.ship.each do |ship|
  			ship.ship_cell.each do |cell|
  				@ship_cells << [cell.row, cell.column]
  			end
  		end

  		respond_to do |format|
  			format.json { render json: @ship_cells }
  		end

  	rescue ActiveRecord::RecordNotFound
  		flash[:alert] = "Game not found!"
		redirect_to '/'
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