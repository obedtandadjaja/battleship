$(document).ready(function() {

	// setUpSocketConnection();

	$('td').click(function() {
		var col = $(this).closest('table').find('th').eq(this.cellIndex).attr('class');
		console.log(col);
		var row = $(this).parent().attr('class');
		if(col == "empty-col") {
			swal("Warning", "Please get your head back in the game", "error")
		} else {
			sendFire(col, row, 1);
			swal("You clicked:", col+" : "+row, "success");
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

	function sendFire(col, row, game_id) {
		$.ajax({
		    url: '/games/'+game_id,
		    type: 'PUT',
		    data: { row: row, col: col},
		    dataType: "json",
		    success: function (response) {
		    	console.log(response);
		    	
		    }, error: function (response) {
	    		alert("Something appears to be wrong");
	    	}
	    });
	}

});