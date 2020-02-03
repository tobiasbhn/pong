class ConsumerDisconnectJob < ApplicationJob
  queue_as :default

  def perform(cookie:, **)
    if Consumer.exists?(id: cookie&.[](:value))
      consumer = Consumer.find(cookie[:value])
      if !consumer.active && consumer.created_at.to_time.to_i == cookie[:time].to_time.to_i
        game_id = consumer.consumable[:game_id].presence || consumer.consumable[:id]
        result = Consumer::Operation::Destroy.(id: consumer.id)
        result = Game::Operation::UpdateQueue.(id: game_id)
      end
    end
  end
end