module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Pong::Helpers
    identified_by :current_consumer

    def connect
      update_consumer
      game_id = current_consumer&.consumable[:game_id].presence || current_consumer&.consumable[:id]
      result = Consumer::Operation::Connect.(id: current_consumer.id)
      result = Game::Operation::UpdateQueue.(id: game_id)
    end

    def disconnect
      cookie = cookie_helper(name: "consumer")
      if Consumer.exists?(id: cookie&.[](:value))
        update_consumer
        result = Consumer::Operation::Disconnect.(id: current_consumer.id)
        ConsumerDisconnectJob.set(wait: 5.seconds).perform_later(cookie: cookie)
      end
    end

    private
    def update_consumer
      cookie = cookie_helper(name: "consumer")
      self.current_consumer = Consumer.find_by(id: cookie&.[](:value))
    end
  end
end
