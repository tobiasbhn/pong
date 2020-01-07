class GameController < ActionController::Base
  def create
    result = Game::Create.(params: params)
    
    if result.success?
      cookies.encrypted[:_pong_id] = result[:model].consumer.id
      redirect_to game_path(game_id: result[:model].id)
    else
      flash[:alert] = "Game creation error"
      # result['contract.default'].errors.messages
      # byebug
      redirect_to new_game_path
    end
  end
end
