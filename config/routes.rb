Rails.application.routes.draw do
  # For all normal Frontend-Pages
  root 'application#index', as: 'index'
  get '/host', to: 'application#host', as: 'new_game'
  post '/host', to: 'game#create', as: 'create_game'

  get '/join', to: 'application#join', as: 'new_user'
  post '/join', to: 'user#create', as: 'create_user'


  # 'Secured'
  get '/:game_id', to: 'application#show', as: 'game', constraints: { game_id: /\d{5}/ }
  post '/:game_id', to: 'user#auth', as: 'user_auth', constraints: { game_id: /\d{5}/ }
end
