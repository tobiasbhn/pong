class ConsumerDisconnectJob < ApplicationJob
  queue_as :default

  def perform(cookie:, **)
    puts "Performing ActiveJob: ConsumerDisconnectJob: Consumer disconnecs from Websocket".green
    if Consumer.exists?(id: cookie&.[](:value))
      consumer = Consumer.find(cookie[:value])
      if !consumer.active && consumer.created_at.to_time.to_i == cookie[:time].to_time.to_i
        puts "Performing ActiveJob: ConsumerDisconnectJob: Destroyed Consumer".red
        result = Consumer::Destroy.(id: consumer.id)
      else
        puts "Performing ActiveJob: ConsumerDisconnectJob: Consumer exist but is not getting destroyed".green
      end
    else
      puts "Performing ActiveJob: ConsumerDisconnectJob: Consumer alredy not existing".green
    end
  end
end