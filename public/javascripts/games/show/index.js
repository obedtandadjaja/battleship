$(document).ready(function() {
	// setUpSocketConnection();

	var root_url = $("#root-url").val();
	var channel = $("#game-channel").val();
	var game_id = $("#game-id").val();
	var current_player = $("#current-player").val();

	// connect to server like normal
	var dispatcher = new WebSocketRails(root_url.replace("http://", "") + 'websocket', false); 

	var click_disabled = false;
	var shot_time = 2000;

	for($i = 1; $i < 11; $i++) {
		var string = '<tr class="'+$i+'">';
		string += "<td><b>"+$i+"</b></td>";
		for($x = 1; $x < 11; $x++) {
			var row = String.fromCharCode(64+$x)
			string += '<td class="cell" id='+row+$i+'>cell</td>';
		}
		string += "</tr>";
		$('tbody').append(string);
	}

	$('td').click(function() {
		if (!click_disabled)
		{
			var col = $(this).closest('table').find('th').eq(this.cellIndex).attr('class');
			console.log(col);
			var row = $(this).parent().attr('class');
			if(col == "empty-col") {
				// swal("Warning", "Please get your head back in the game", "error")
			} else {
				if ($(this).hasClass("cell"))
				{
					fire(col, row, game_id, channel);
					$(this).removeClass();
					$(this).addClass("miss");
					$(this).html("miss");
					// sendFire(col, row, 1);
					// swal("You clicked:", col+" : "+row, "success");
					click_disabled = true;
					move(function() {click_disabled = false;});
				}
			}
		}
	});

	var sub_channel = dispatcher.subscribe(channel);

	sub_channel.bind('update_board', function(data) {
		console.log('channel event received: ' + data);
	});
	
	// Destroyed game. Kick all players from the lobby
	sub_channel.bind('destroy', function(response) {
		// console.log(response);
		// Disable onbeforeunload on redirect
		window.onbeforeunload = function() {}
		window.location = "/";
	});

	sub_channel.bind('hit', function(position) {
		var c = position[0];
		var r = position[1];
		cell = $("#" + c + r);
		cell.removeClass();
		cell.addClass("hit");
		cell.html("hit");
	});

	function fire(col, row, game_id, channel)
	{
		var message_data = { "col": col, "row": row, "channel": channel };
  		dispatcher.trigger('fire', JSON.stringify(message_data));
	}

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

	function getShips() {
		$.ajax({
			url: '/games/get_ships/'+game_id+'/'+current_player,
			method: "PUT",
			data: {},
			success: function(response) {
				$.each(response, function(index, array) {
					$("#"+array[0]+array[1]).text("ship");
				});
			}
		});
	}

	getShips();

});