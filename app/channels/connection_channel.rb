class ConnectionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "connection_#{game_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end