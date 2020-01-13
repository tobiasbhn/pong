module Pong::Cell
  class Base < Trailblazer::Cell
    include Pong::Helpers

    def flash
      flash = parent_controller.flash
    end

    def default_url_options
      { lang: I18n.locale }
    end
  end
end