# Public: Operation to present a Game.
#
#   Consumer::Operation::Present.(
#     params: {}
#   )
#
# Returns a Trailblazer::Operation::Result object.
class Game::Operation::Present < Trailblazer::Operation
  step Model(Game, :new)
  step Contract::Build(constant: Game::Contract::Create)
end