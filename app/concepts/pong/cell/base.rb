module Pong::Cell
  class Base < Trailblazer::Cell
    include Pong::Helpers

    def flash
      flash = parent_controller.flash
    end
  end
end