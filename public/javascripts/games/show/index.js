$(document).ready(function() {

	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();
	var current_player = $("#current-player").val();

	// Should work in development and live
	var dispatcher = new WebSocketRails(root_url.replace("http://", "") + 'websocket');
	
	dispatcher.on_open = function(data) {
  		var message_data = { "channel": channel, "game_id": game_id };
  		// Make sure that breakdown is not called after
  		setTimeout(function(){ dispatcher.trigger('setupgame', JSON.stringify(message_data)); }, 500);
	}

	$('td').click(function() {
		var col = $(this).closest('table').find('th').eq(this.cellIndex).attr('class');
		var row = $(this).parent().attr('class');
		if(col == "empty-col") {
			swal("Warning", "Please get your head back in the game", "error")
		} else {
			console.log(row+" - "+col);
			var message_data = { "channel": channel, "game_id": game_id, "row": row, "col": col };
	  		dispatcher.trigger('guess', JSON.stringify(message_data));
			// swal("You clicked:", col+" : "+row, "success");
		}
	});

	// Destroyed game. Kick all players from the lobby
	sub_channel.bind('destroy', function(response) {
		// console.log(response);
		// Disable onbeforeunload on redirect
		window.onbeforeunload = function() {}
		window.location = "/";
	});

});