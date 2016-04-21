class LobbySocketController < WebsocketRails::BaseController

	def setup
		# Get channel and game from client
		channel = ActiveSupport::JSON.decode(message)["channel"]
		game_id = ActiveSupport::JSON.decode(message)["game_id"]

		# Get all players in this game
		players = GamePlayer.where(game_id: game_id)

		# Add them to an array
		player_array = []
		players.each do |player|
			player_array.append player.user.name
		end

		# Broadcast list of players to everyone in the lobby
		WebsocketRails[channel].trigger(:update, player_array)
	end

	def breakdown
		user = current_or_guest_user

		# Problem here is that we are planning on storing completed games, so you have to find the non-completed game instead of just the first entry. Otherwise, we will accidentally destroy all previous games in which this user has participated
		gameplayer = GamePlayer.where(user_id: user.id).first

		# Get current game
		game = gameplayer.game
		# Get the channel of that game
		channel = game.channel

		# Delete this user from that game
		GamePlayer.where(["game_id = ? and user_id = ?", game.id, user.id]).destroy_all

		# Get all players left in the game
		players = GamePlayer.where(game_id: game.id)

		# Add them to an array
		player_array = []
		players.each do |player|
			player_array.append player.user.name
		end

		# Broadcast list of players to everyone in the lobby
		WebsocketRails[channel].trigger(:update, player_array)
	end


end
