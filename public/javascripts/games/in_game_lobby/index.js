window.onbeforeunload = function() {
    return "Reloading or exiting page will get you out of the game";
}

$(document).ready(function() {

	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();
	var current_player = $("#current-player").val();

	// Set player list test to loading until the data is loaded from the server
	$(".players ul").empty();
  	$(".players ul").append("<li>Loading...</li>");

  	function checkGameExists() {
  		$.ajax({
  			url: "/games/check/"+game_id,
  			method: "PUT",
  			data: {user_slug: current_player},
  			success: function(response) {
  				if(!response) {
  					window.onbeforeunload = function() {}
					window.location = "/";
				}
  			}
  		})
  	}
  	checkGameExists();

	// Should work in development and live
	var dispatcher = new WebSocketRails(root_url.replace("http://", "").replace("https://", "") + 'websocket');  
	
	dispatcher.on_open = function(data) {
  		var message_data = { "channel": channel, "game_id": game_id };
  		// Make sure that breakdown is not called after
  		setTimeout(function(){ dispatcher.trigger('setuplobby', JSON.stringify(message_data)); }, 500);
	}

	// Websocket when user hits play
	$('#play-button').click(function() {
  		var message_data = { "channel": channel, "game_id": game_id };
  		// $(this).addClass("disabled");
  		$(this).html("Loading...");
  		// $(this).attr("disabled", true);
  		// Make sure that breakdown is not called after
  		setTimeout(function(){ dispatcher.trigger('playgame', JSON.stringify(message_data)); }, 500);
  	});

	var sub_channel = dispatcher.subscribe(channel);
	sub_channel.bind('update', function(players) {
		if (players.length == $("#num-players").val()) {
			$("#play-button").attr("disabled", false);
			$("#play-button").removeClass("disabled");
		}
		// Empty out the player list
		$(".players ul").empty();
		// Add each player from the server
		$.each(players, function(index, player) {
			$(".players ul").append("<li id="+ player.slug +">" + player.name + "</li>");
		});
		if($('.players ul li').find('#current_player').count == 0) {
			window.location = "/";
		}
	});

	// Starting game. Redirect all players to game board
	sub_channel.bind('playgame', function(response) {
		// console.log(response);
		// Disable onbeforeunload on redirect
		window.onbeforeunload = function() {}
		window.location = "/games/"+response;
	});

	// Destroyed game. Kick all players from the lobby
	sub_channel.bind('destroy', function(response) {
		// console.log(response);
		// Disable onbeforeunload on redirect
		window.onbeforeunload = function() {}
		window.location = "/";
	});

	$('.modal-trigger').leanModal();
});