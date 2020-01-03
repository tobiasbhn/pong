class Game::Activate < Trailblazer::Operation
  step :activate!

  def activate!(options, game:, **)
    options[:model] = Game.find(game)
    options[:model].active = true;
    options[:model].save
  end
end