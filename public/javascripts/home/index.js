$(document).ready(function() {

	$('.modal-trigger').leanModal();

	setTimeout(function(){ reloadGames(); }, 500);

	function reloadGames() {
		$('.chaos_games').load('/get_chaos_games');
		$('.traditional_games').load('/get_traditional_games');
		$('.modal-trigger').leanModal();
		console.log("triggered!");
	}
	
	var root_url = $("#root-url").val();
	var channel = "gameindex";

	// Websocket
	var dispatcher = new WebSocketRails(root_url.replace("http://", "") + 'websocket');

	var sub_channel = dispatcher.subscribe(channel);
	sub_channel.bind('update', function(response) {
		reloadGames();
	});

});