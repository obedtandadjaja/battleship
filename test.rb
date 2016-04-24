@user_ships = Hash.new
@user_ships[5] = Array.new
@user_ships[5][0] = Array.new
@user_ships[5][0] << ["E", 9]
@user_ships[5][0] << ["E", 10]
@user_ships[5][1] = Array.new
@user_ships[5][1] << ["D", 5]
@user_ships[5][1] << ["C", 5]

@user_ships.each do |key, value|
  # @player = GamePlayer.where(game_id: game_id, user_id: key).first
  value.each do |i|
    # ship = Ship.create(game_player_id: @player.id, is_sunk: false)
    i.each do |x|
      # ShipCell.create(ship_id: ship.id, row: x[0], column: x[1], is_hit: false)
      puts "#{x[0]}, #{x[1]}"
    end
  end
end
