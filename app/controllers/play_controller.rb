class PlayController < WebsocketRails::BaseController
  	
  	def initialize_session
    	# perform application setup here
    	controller_store[:message_count] = 0
  	end

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
					ShipCell.create(ship_id: ship.id, column: x[0], row: x[1], is_hit: false)
				end
			end
		end

		# Send redirect broadcast
  		WebsocketRails[channel].trigger(:playgame, @game.slug)
  	end

  	def fire
  		channel = ActiveSupport::JSON.decode(message)["channel"]
		col = ActiveSupport::JSON.decode(message)["col"]
		row = ActiveSupport::JSON.decode(message)["row"]

		# is_hit = [true, false].sample
		# if is_hit
		# 	WebsocketRails[channel].trigger(:hit, [col, row])
		# end
		@game = Game.find_by_channel(channel)
		@user = current_or_guest_user
		@players = GamePlayer.where(game_id: @game.id)
		@player = GamePlayer.where(game_id: @game.id, user_id: @user.id).first
		if @player.ships_left
			@players.each do |user|
				if user.id == @user.id
					next
				else
					user.ship.each do |ship|
						# puts ship.ship_cell
						if ship.is_sunk == false
							# ship sunk flag
							is_sunk = true
							ship.ship_cell.each do |ship_cell|
								# puts "ship: #{ship_cell.column}#{ship_cell.row}"
								puts "guess: #{col}#{row}"
								# if hit
								puts "Entered ship loop"
								if ship_cell.row == row && ship_cell.column == col
									puts "Hit ship cell"
									# update to is_hit
									ship_cell.update_attributes(is_hit: true)
									# update score
									@player.update_attributes(score: @player.score+1)
									# create guess
									Guess.create(game_player_id: @player.id, row: row, col: col, is_hit: true)
									# broadcast
									WebsocketRails[channel].trigger(:hit, [col, row])
									break
								else
									# create guess
									Guess.create(game_player_id: @player.id, row: row, col: col, is_hit: false)
									# if one of the ship cell is not hit then ship not sunk
									if ship_cell.is_hit == false
										is_sunk = false
									end
								end
							end

							# check if ship has sunk
							if is_sunk == true
								ship.update_attributes(is_sunk: true)
							end
						else
							next
						end
					end
				end
			end
		end

		# check gameover
		@game.user.each do |user|
			gameover = true
			user.ship.each do |ship|
				if ship.is_sunk == false
					gameover = false
				end
			end
			if gameover
				player = GamePlayer.where(game_id: @game.id, user_id: user.id).first
				player.update_attributes(ships_left: false)
				user.update_attributes(total_score: user.total_score+player.score)
				WebsocketRails[channel].trigger(:gameover, player.score)
			end
		end
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
  		first_col = rand(65..75)
  		first_row = rand(1..10)

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
  				if(first_col-1 > 64)
	  				second_col = first_col-1
	  			elsif(first_col+1 < 76)
	  				second_col = first_col+1
	  			end
  			else
  				if(first_col+1 < 64)
	  				second_col = first_col+1
	  			elsif(first_col-1 > 76)
	  				second_col = first_col-1
	  			end
  			end
  		end

  		return [[first_col.chr, first_row], [second_col.chr, second_row]]
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

end
