Rails.application.routes.draw do
  # For all normal Frontend-Pages
  root 'application#index', as: 'index'
  get '/host', to: 'application#game', as: 'new_game'
  get '/join', to: 'application#user', as: 'new_user'
  # 'Secured'
  get '/game/:game_id', to: 'application#show', as: 'game'


  # Backend Stuff
  post '/game/create', to: 'game#create', as: 'create_game'
  post '/user/create', to: 'user#create', as: 'create_user'
end
