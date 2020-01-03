class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{game_id}"

    if is_host?
      Game::Activate.(game: game_id)
    end
  end

  def unsubscribed
    stop_all_streams
    
    if is_host?
      Game::Deactivate.(game: game_id)
    end
  end
end