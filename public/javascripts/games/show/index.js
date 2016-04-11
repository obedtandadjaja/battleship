$(document).ready(function() {

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

	dispatcher.bind('update_board', function(data) {
	  	console.log(data);
	});

});