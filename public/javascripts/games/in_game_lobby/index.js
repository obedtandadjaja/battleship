$(document).ready(function() {

	$('.modal-trigger').leanModal();

    setInterval(function() {
        reloadGames();
    }, 500);

	function reloadGames() {
		$('.players').load('/get_in_game_lobby_players/'+$('.players').attr('id'));
		console.log("triggered!");
	}
});