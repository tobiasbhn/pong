class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_#{game_id}"

    current_consumer.active = true
    current_consumer.save
  end

  def unsubscribed
    current_consumer.active = false
    current_consumer.save

    stop_all_streams
  end
end