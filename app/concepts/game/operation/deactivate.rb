class Game::Deactivate < Trailblazer::Operation
  step :deactivate!
  # TODO: step :kick_players!

  def deactivate!(options, game:, **)
    options[:model] = Game.find(game)
    options[:model].active = false;
    options[:model].save
  end
end