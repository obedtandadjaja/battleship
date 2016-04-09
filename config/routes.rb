Rails.application.routes.draw do

  devise_for :users
  root 'home#index'

  #ajax route for hit
  put '/games/:game_id/:row/:col' => 'games#guess'

end
