$(document).ready(function() {
	setUpSocketConnection();

	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();
	var current_player = $("#current-player").val();

	var click_disabled = false;
	var shot_time = 2000;

	$('td').click(function() {
		if (!click_disabled)
		{
			var col = $(this).closest('table').find('th').eq(this.cellIndex).attr('class');
			console.log(col);
			var row = $(this).parent().attr('class');
			if(col == "empty-col") {
				// swal("Warning", "Please get your head back in the game", "error")
			} else {
				// sendFire(col, row, 1);
				// swal("You clicked:", col+" : "+row, "success");
			}
			click_disabled = true;
			move(function() {click_disabled = false;});
		}
	});

	function setUpSocketConnection() {
		// connect to server like normal
		var dispatcher = new WebSocketRails('localhost:3000/websocket');

		// subscribe to the channel
		var channel = dispatcher.subscribe($('.channel-name').text());

		// You can also pass an object to the subscription event
		// var channel = dispatcher.subscribe({channel: 'channel_name', foo: 'bar'});

		// bind to a channel event
		channel.bind('update_board', function(data) {
		  	console.log('channel event received: ' + data);
		});
	}

	function fire(col, row, game_id)
	{
		var message_data = { "col": col, "row": row, "game_id": game_id };
  		dispatcher.trigger('fire', JSON.stringify(message_data));
	}


	var sub_channel = dispatcher.subscribe(channel);
	
	// Destroyed game. Kick all players from the lobby
	sub_channel.bind('destroy', function(response) {
		// console.log(response);
		// Disable onbeforeunload on redirect
		window.onbeforeunload = function() {}
		window.location = "/";
	});

	// Progress Bar
	function move(callback) {
	    var elem = $("#progress-bar"); 
	    var width = 1;
	    var id = setInterval(frame, 10);
	    $("#label").html("Reloading...");
	    function frame() {
	        if (width >= 100) {
	            clearInterval(id);
	            $("#label").html("Fire!")
	            callback();
	        } else {
	            width++; 
	            elem.width(width + '%');
	        }
	    }
	}

});