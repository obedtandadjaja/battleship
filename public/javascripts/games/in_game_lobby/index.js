$(document).ready(function() {
	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();

	// Should work in development and live
	var dispatcher = new WebSocketRails(root_url.replace("http://", "") + 'websocket'); 
	
	dispatcher.on_open = function(data) {  
  		var message_data = { "channel": channel, "game_id": game_id };
  		dispatcher.trigger('setuplobby', JSON.stringify(message_data));
	}

	var sub_channel = dispatcher.subscribe(channel);  
	sub_channel.bind('update', function(players) { 
		// Empty out the player list
		$(".players ul").empty();
		// Add each player from the server
		$.each(players, function(index, player) {
			$(".players ul").append("<li>" + player + "</li>");
		});
	});

	// $('.modal-trigger').leanModal();

 //    setInterval(function() {
 //        reloadGames();
 //    }, 500);

	// function reloadGames() {
	// 	$('.players').load('/get_in_game_lobby_players/'+$('.players').attr('id'));
	// 	console.log("triggered!");
	// }
});