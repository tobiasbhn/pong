module Game::Cell
  class Show < Pong::Cell::Base
    def consumer
      Consumer.find_by(id: consumer_cookie&.[](:value))
    end

    def game
      Game.find_by(id: params[:game_id])
    end
  end
end