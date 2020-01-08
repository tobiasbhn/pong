class Consumer::Destroy < Trailblazer::Operation
  step :model!
  step :notify!
  step :destroy!

  def model!(options, **)
    options[:model] = Consumer.find(options[:id])
  end

  def notify!(options, model:, **)
    if model.consumable_type == "Game"
      ActionCable.server.broadcast("game_#{model.consumable&.id}", "Host disconnected!")
    else
      ActionCable.server.broadcast("game_#{model.consumable&.game_id}", "User disconnected!")
    end
    true
  end

  def destroy!(options, model:, **)
    options[:model].destroy
  end
end