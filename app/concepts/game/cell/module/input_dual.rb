module Game::Cell::Module
  class InputDual < Pong::Cell::Base
    def consumer
      model[:consumer]
    end

    def game
      model[:game]
    end
  end
end