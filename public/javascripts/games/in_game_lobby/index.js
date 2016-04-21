$(document).ready(function() {

	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();

	// Set player list test to loading until the data is loaded from the server
	$(".players ul").empty();
  	$(".players ul").append("<li>Loading...</li>");

  	function playGame()
  	{
  		alert("Play game");
  	}

	// Should work in development and live
	var dispatcher = new WebSocketRails(root_url.replace("http://", "") + 'websocket'); 
	
	dispatcher.on_open = function(data) {  
  		var message_data = { "channel": channel, "game_id": game_id };
  		// Make sure that breakdown is not called after
  		setTimeout(function(){ dispatcher.trigger('setuplobby', JSON.stringify(message_data)); }, 500);
	}

	var sub_channel = dispatcher.subscribe(channel);  
	sub_channel.bind('update', function(players) { 
		if (players.length == $("#num-players").val())
		{
			$("#play-button").attr("disabled", false);
			$("#play-button").removeClass("disabled");
		}

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