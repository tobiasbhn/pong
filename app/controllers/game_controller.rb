class GameController < ActionController::Base
  include Pong::Helpers

  def create
    puts "Using Controller Action: Game#Create".green
    result = Game::Create.(params: params, cookie: consumer_cookie)
    
    if result.success?
      puts "Game#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      protect_cookie(result[:model]) if result[:model].protect
      redirect_to game_path(game_id: result[:model].id)
    else
      puts "Game#Create Operation failure".red
      flash[:alert] = "Game creation error"
      # result['contract.default'].errors.messages
      # byebug
      redirect_to new_game_path # TODO: irgendwie contract.default mit geben
    end
  end
end
