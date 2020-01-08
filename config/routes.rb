Rails.application.routes.draw do
  # For all normal Frontend-Pages
  root 'application#index', as: 'index'
  get '/host', to: 'application#host', as: 'new_game'
  get '/(:game_id)/join', to: 'application#join', as: 'new_user'

  # Backend Stuff
  post '/game/create', to: 'game#create', as: 'create_game'
  post '/user/create', to: 'user#create', as: 'create_user'
  post '/user/auth', to: 'user#auth', as: 'user_auth'


  # 'Secured'
  get '/:game_id', to: 'application#show', as: 'game', constraints: { game_id: /\d{5}/ }
end
