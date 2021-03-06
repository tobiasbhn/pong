# Public: Operation destroy a Consumer and send a Broadcast to the Game Channel.
#
# Examples
#
#     Consumer::Operation::Destroy.(
#       id: Consumer[:id]
#     )
#
# Returns a Trailblazer::Operation::Result object.
class Consumer::Operation::Destroy < Trailblazer::Operation
  step :model!
  pass :notify!
  step :destroy!

  def model!(options, **)
    options[:model] = Consumer.find_by(id: options[:id])
  end

  def notify!(options, model:, **)
    game_id = model.consumable[:game_id].presence || model.consumable[:id]
    ActionCable.server.broadcast("game_#{game_id}", "#{model.consumable_type} disconnected!")
  end

  def destroy!(options, model:, **)
    options[:model].destroy
  end
end