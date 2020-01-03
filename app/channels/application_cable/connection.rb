module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_consumer

    def connect
      self.current_consumer = Consumer.find_by(id: cookies.encrypted[:id])
    end
  end
end
