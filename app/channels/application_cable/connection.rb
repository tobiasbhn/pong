module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_consumer

    def connect
      update_consumer
      current_consumer.active = true
      current_consumer.client_count += 1;
      current_consumer.save
    end

    def disconnect
      update_consumer
      current_consumer.client_count = current_consumer.client_count - 1;
      current_consumer.active = false if current_consumer.client_count <= 0
      current_consumer.save
    end

    def update_consumer
      self.current_consumer = Consumer.find_by(id: cookies.encrypted[:_pong_id])
    end
  end
end
