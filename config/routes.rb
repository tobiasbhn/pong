Rails.application.routes.draw do
  # For all normal Frontend-Pages
  root 'pages#index', as: 'index'
  get '/host', to: 'pages#host', as: 'new_game'
  post '/host', to: 'games#create', as: 'create_game'

  get '/join', to: 'pages#join', as: 'new_user'
  post '/join', to: 'users#create', as: 'create_user'


  # 'Secured'
  get '/:game_id', to: 'pages#show', as: 'game', constraints: { game_id: /\d{5}/ }
  post '/:game_id', to: 'users#auth', as: 'user_auth', constraints: { game_id: /\d{5}/ }
end
