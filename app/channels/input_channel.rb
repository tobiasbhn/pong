class InputChannel < ApplicationCable::Channel
  def subscribed
    stream_from "input_#{game_id}"
  end

  def unsubscribed
    stop_all_streams
  end
end