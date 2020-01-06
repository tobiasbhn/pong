module Page::Cell
  class Index < Trailblazer::Cell
    def flash
      flash = parent_controller.flash
    end
  end
end