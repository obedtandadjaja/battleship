Rails.application.routes.draw do

  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions'
    }
  end

  root 'home#index'

  #ajax route for hit
  put '/games/:game_id' => 'games#guess'

  post '/create_guest' => 'users#create_guest'
  delete '/destroy_guest' => 'users#destroy_guest'

  resources :games
  resources :users

end
