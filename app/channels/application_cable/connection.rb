module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Pong::Helpers
    identified_by :current_consumer

    def connect
      update_consumer
      game_id = current_consumer&.consumable[:game_id].presence || current_consumer&.consumable[:id]
      result = Consumer::Operation::Connect.(id: current_consumer.id)
      result = Game::Operation::UpdateQueue.(id: game_id)
      puts "A User Connected. ID: #{current_consumer&.id} | Active Instances: #{current_consumer&.instance_count}".socket
    end

    def disconnect
      if Consumer.exists?(id: consumer_cookie&.[](:value))
        update_consumer
        result = Consumer::Operation::Disconnect.(id: current_consumer.id)
        ConsumerDisconnectJob.set(wait: 5.seconds).perform_later(cookie: consumer_cookie)

        puts "A User Disconnected. ID: #{current_consumer&.id} | Active Instances: #{current_consumer&.instance_count}".socket
        puts "A User Disconnected. Started ActiveJob: ConsumerDisconnectJob".socket
      else
        puts "A User Disconnected. Hes probably already destroyed".socket
      end
    end

    private
    def update_consumer
      self.current_consumer = Consumer.find_by(id: consumer_cookie&.[](:value))
    end
  end
end
