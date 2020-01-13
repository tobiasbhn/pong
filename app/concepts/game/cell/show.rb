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
        "Would render Game View without Controlls"
      when ["Game", "multiplayer"]
        "Would render Game View with one side Controlls"
      when ["Game", "splitscreen"]
        "Would render Game View with both Controlls"
      when ["User", "party"]
        "Would render Only Controlls"
      when ["User", "multiplayer"]
        "Would render Game view with one side Controlls"
      when ["User", "splitscreen"]
        "Probably not possible"
      else
        "Else (Type: #{consumer.consumable_type}; Mode: #{game.mode})"
      end
    end
  end
end