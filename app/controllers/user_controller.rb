class UserController < ActionController::Base
  include Pong::Helpers

  def create
    result = User::Create.(params: params)
    
    if result.success?
      consumer_cookie(result[:model].consumer.id)
      redirect_to game_path(game_id: result[:model].game_id)
    else
      flash[:alert] = "User creation error"
      redirect_to new_user_path
    end
  end

  def auth
    game = Game.find(params[:password][:id])
    if game&.authenticate(params[:password][:password])
      protect_cookie(game.id)
      redirect_to game_path(game_id: game.id)
    else
      flash[:alert] = "Wrong Password."
      render(html: cell(Page::Cell::Password, nil, id: game.id).(), layout: 'application', status: :ok)
    end
  end
end
