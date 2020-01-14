module Pong::Cell
  class Flash < Pong::Cell::Base
    def flash
      flash = parent_controller.flash
    end
  end
end