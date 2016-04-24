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

		# Send redirect broadcast
  		WebsocketRails[channel].trigger(:playgame, @game.slug)
  	end

  	def fire
  		channel = ActiveSupport::JSON.decode(message)["channel"]
		game_id = ActiveSupport::JSON.decode(message)["game_id"]
		col = ActiveSupport::JSON.decode(message)["col"]
		row = ActiveSupport::JSON.decode(message)["row"]

		is_hit = [true, false].sample

		if is_hit
			WebsocketRails[channel].trigger(:hit, [col, row])
		end
  	end
	
end