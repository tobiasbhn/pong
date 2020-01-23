class ConsumerDisconnectJob < ApplicationJob
  queue_as :default

  def perform(cookie:, **)
    Rails.logger.debug "Performing ActiveJob: ConsumerDisconnectJob: Consumer disconnecs from Websocket".green
    if Consumer.exists?(id: cookie&.[](:value))
      consumer = Consumer.find(cookie[:value])
      if !consumer.active && consumer.created_at.to_time.to_i == cookie[:time].to_time.to_i
        Rails.logger.debug "Performing ActiveJob: ConsumerDisconnectJob: Destroyed Consumer".red
        game_id = consumer.consumable[:game_id].presence || consumer.consumable[:id]
        result = Consumer::Operation::Destroy.(id: consumer.id)
        result = Game::Operation::UpdateQueue.(id: game_id)
      else
        Rails.logger.debug "Performing ActiveJob: ConsumerDisconnectJob: Consumer exist but is not getting destroyed".green
      end
    else
      Rails.logger.debug "Performing ActiveJob: ConsumerDisconnectJob: Consumer alredy not existing".green
    end
  end
end