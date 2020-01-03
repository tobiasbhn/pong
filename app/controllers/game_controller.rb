class GameController < ActionController::Base
  def create
    result = Game::Create.(params: params)
    
    if result.success?
      cookies.encrypted[:id] = result[:model].consumer.id
      redirect_to game_path(game_id: result[:model].id)
    else
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end
end
