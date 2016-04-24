def randomize_ship_cells
  		# Randomize two 2x1 ships
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
	  					@game_cells[1] << random_ship[0]
	  					@game_cells[1] << random_ship[1]
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

  		return [[first_row.chr, first_col], [second_row.chr, second_col]]
  	end

puts random_ship