class Consumer::Destroy < Trailblazer::Operation
  step :model!
  step :destroy!

  def model!(options, **)
    options[:model] = Consumer.find(options[:id])
  end

  def destroy!(options, model:, **)
    if model.consumable_type == "Game"
      result = Game::Destroy.(id: model.consumable.id)
    else
      result = User::Destroy.(id: model.consumable.id)
    end
    result.success?
  end
end