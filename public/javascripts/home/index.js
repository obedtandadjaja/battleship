$(document).ready(function() {

	$('.modal-trigger').leanModal();

    setInterval(function() {
        reloadGames();
    }, 500);

	function reloadGames() {
		$('.chaos_games').load('/get_chaos_games');
		$('.traditional_games').load('/get_traditional_games');
		$('.modal-trigger').leanModal();
		console.log("triggered!");
	}

});