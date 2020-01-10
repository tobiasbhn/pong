Rails.application.routes.draw do
  
  root 'pages#index', as: 'index'
  get '/host', to: 'games#new', as: 'new_game'
  post '/host', to: 'games#create', as: 'create_game'

  get '/join', to: 'users#new', as: 'new_user'
  post '/join', to: 'users#create', as: 'create_user'

  get '/:game_id', to: 'games#show', as: 'game', constraints: { game_id: /\d{5}/ }
  post '/:game_id', to: 'users#auth', as: 'user_auth', constraints: { game_id: /\d{5}/ }
end
