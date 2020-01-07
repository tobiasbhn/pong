module Pong::Cell
  class Base < Trailblazer::Cell
    def flash
      flash = parent_controller.flash
    end
  end
end