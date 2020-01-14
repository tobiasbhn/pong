module Pong::Cell
  class Base < Trailblazer::Cell
    include Pong::Helpers
    include Pong::Util::Form

    def default_url_options
      { lang: I18n.locale }
    end
  end
end