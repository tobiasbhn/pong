Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get '/pong', to: 'game#create'
  get '/play', to: 'user#create'

  get '/:game_id', to: 'application#show'
end
