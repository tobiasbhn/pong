class Consumer::Operation::Destroy < Trailblazer::Operation
  step :model!
  pass :notify!
  step :destroy!

  def model!(options, **)
    puts "Consumer::Destroy::Operation: model".tb
    options[:model] = Consumer.find_by(id: options[:id])
  end

  def notify!(options, model:, **)
    puts "Consumer::Destroy::Operation: notify".tb
    game_id = model.consumable[:game_id].presence || model.consumable[:id]
    ActionCable.server.broadcast("game_#{game_id}", "#{model.consumable_type} disconnected!")
  end

  def destroy!(options, model:, **)
    puts "Consumer::Destroy::Operation: destroy".tb
    options[:model].destroy
  end
end