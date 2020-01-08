module Page::Cell
  class Show < Pong::Cell::Base
    def consumer
      Consumer.find(consumer_cookie)
    end

    def game
      Game.find(params[:game_id])
    end
  end
end