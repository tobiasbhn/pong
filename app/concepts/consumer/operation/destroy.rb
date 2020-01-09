class Consumer::Destroy < Trailblazer::Operation
  step :model!
  pass :notify!
  step :destroy!

  def model!(options, **)
    puts "Consumer::Destroy::Operation: model".tb
    options[:model] = Consumer.find_by(id: options[:id])
  end

  def notify!(options, model:, **)
    puts "Consumer::Destroy::Operation: notify".tb
    if model.consumable_type == "Game"
      ActionCable.server.broadcast("game_#{model.consumable&.id}", "Host disconnected!")
    else
      ActionCable.server.broadcast("game_#{model.consumable&.game_id}", "User disconnected!")
    end
  end

  def destroy!(options, model:, **)
    puts "Consumer::Destroy::Operation: destroy".tb
    options[:model].destroy
  end
end