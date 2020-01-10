class Game::Present < Trailblazer::Operation
  step Model(Game, :new)
  step Contract::Build(constant: Game::Contract::Create)
end