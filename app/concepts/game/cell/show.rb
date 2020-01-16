module Game::Cell
  class Show < Pong::Cell::Base
    def consumer
      Consumer.find_by(id: consumer_cookie&.[](:value))
    end

    def game
      Game.find_by(id: params[:game_id])
    end

    def get_cells
      case [consumer.consumable_type, game.mode]
      when ["Game", "party"]
        module1 = cell(Game::Cell::Module::Connection, consumer: consumer, game: game)
        module2 = cell(Game::Cell::Module::Game, consumer: consumer, game: game)
        "#{module1}#{module2}".html_safe
      when ["Game", "multiplayer"], ["User", "multiplayer"]
        module1 = cell(Game::Cell::Module::Connection, consumer: consumer, game: game)
        module2 = cell(Game::Cell::Module::Game, consumer: consumer, game: game)
        module3 = cell(Game::Cell::Module::InputSingle, consumer: consumer, game: game)
        "#{module1}#{module2}#{module3}".html_safe
      when ["Game", "splitscreen"]
        module1 = cell(Game::Cell::Module::Connection, consumer: consumer, game: game)
        module2 = cell(Game::Cell::Module::Game, consumer: consumer, game: game)
        module3 = cell(Game::Cell::Module::InputDual, consumer: consumer, game: game)
        "#{module1}#{module2}#{module3}".html_safe
      when ["User", "party"]
        module1 = cell(Game::Cell::Module::Connection, consumer: consumer, game: game)
        module2 = cell(Game::Cell::Module::InputSingle, consumer: consumer, game: game)
        "#{module1}#{module2}".html_safe
      else
        "Else (Type: #{consumer.consumable_type}; Mode: #{game.mode})"
      end
    end
  end
end