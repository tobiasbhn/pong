class ConsumerDisconnectJob < ApplicationJob
  queue_as :default

  def perform(id:, **)
    if Consumer.exists?(id: id)
      consumer = Consumer.find(id)
      if !consumer.active
        result = Consumer::Destroy.(id: id)
        puts result.success?
      end
    end
  end
end