class GameController < ActionController::Base
  include Pong::Helpers

  def create
    result = Game::Create.(params: params)
    
    if result.success?
      consumer_cookie(result[:model].consumer.id)
      protect_cookie(result[:model].id) if result[:model].protect
      redirect_to game_path(game_id: result[:model].id)
    else
      flash[:alert] = "Game creation error"
      # result['contract.default'].errors.messages
      # byebug
      redirect_to new_game_path
    end
  end
end
