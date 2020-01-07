class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{game_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end