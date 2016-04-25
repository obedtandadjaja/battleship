
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
			else
				second_row = first_row+1
			end
		else
			if(first_row+1 < 11)
				second_row = first_row+1
			else
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
			else
				second_col = first_col+1
			end
		else
			if(first_col+1 < 64)
				second_col = first_col+1
			else
				second_col = first_col-1
			end
		end
	end

	return [[first_col.chr, first_row], [second_col.chr, second_row]]
end

puts random_ship