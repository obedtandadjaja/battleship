Rails.application.routes.draw do

  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end

  root 'home#index'

  post '/create_guest' => 'users#create_guest'
  delete '/destroy_guest' => 'users#destroy_guest'

  get '/games/in_game_lobby/:id' => 'games#in_game_lobby'
  post '/games/authorize/:id' => 'games#authorize'

  get '/get_chaos_games' => 'games#get_chaos_games'
  get '/get_traditional_games' => 'games#get_traditional_games'
  get '/get_in_game_lobby_players/:id' => 'games#get_in_game_lobby_players'
  post '/games/invite/:id' => 'games#invite'
  put '/games/check/:id' => 'games#check'
  put '/games/get_ships/:id/:user_slug' => 'games#get_ships'
  put '/games/get_guesses/:id/:user_slug' => 'games#get_guesses'
  get '/games/get_scores/:id' => 'games#get_scores'

  resources :games
  resources :users

end
