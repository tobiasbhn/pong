module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Pong::Helpers
    identified_by :current_consumer

    def connect
      update_consumer
      current_consumer&.active = true
      current_consumer&.client_count += 1;
      current_consumer&.save
      puts "A User Connected. ID: #{current_consumer&.id} | Active Instances: #{current_consumer&.client_count}".socket
    end

    def disconnect
      if Consumer.exists?(id: consumer_cookie&.[](:value))
        update_consumer
        current_consumer&.client_count = current_consumer&.client_count - 1;
        current_consumer&.active = false if current_consumer&.client_count <= 0
        current_consumer&.save
        puts "A User Disconnected. ID: #{current_consumer&.id} | Active Instances: #{current_consumer&.client_count}".socket

        ConsumerDisconnectJob.set(wait: 7.seconds).perform_later(cookie: consumer_cookie)
        puts "A User Disconnected. Started ActiveJob: ConsumerDisconnectJob".socket
      else
        puts "A User Disconnected. Hes probably already destroyed".socket
      end
    end

    def update_consumer
      self.current_consumer = Consumer.find_by(id: consumer_cookie&.[](:value))
    end
  end
end
