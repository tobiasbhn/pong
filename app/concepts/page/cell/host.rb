module Page::Cell
  class Host < Pong::Cell::Base
    def model
      super || Game.new
    end
  end
end