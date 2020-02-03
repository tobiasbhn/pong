# Public: Operation to create a Game.
# ID and Key of a the Game are not required and generated.
#
#   Consumer::Operation::Connect.(
#     params: {
#       game: {
#         mode: 'multiplayer',
#         password: [PASSWORD],
#         legal: '1'
#       },
#       cookie: cookie
#     }
#   )
#
# Returns a Trailblazer::Operation::Result object.
class Game::Operation::Create < Trailblazer::Operation
  step Subprocess(Game::Operation::Present)
  step :define_id!
  step :define_key!
  step Contract::Validate(key: :game)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  def define_id!(options, params:, **)
    params[:game][:id]
    while params[:game][:id].nil?
      id = rand(10000..99999)
      params[:game][:id] = id unless Game.exists?(id: id)
    end
    params[:game][:id].present?
  end

  def define_key!(options, params:, **)
    num_space = ('2'..'9').to_a
    char_space = ('a'..'h').to_a + ('j'..'k').to_a + ('m'..'z').to_a
    cap_space = ('A'..'H').to_a + ('J'..'K').to_a + ('M'..'Z').to_a
    params[:game][:key] = (num_space + char_space + cap_space).shuffle.first(5).join
    params[:game][:key].present?
  end

  def kick_old_consumer!(options, **)
    if options[:cookie].present?
      result = Consumer::Operation::KickPrevious.(cookie: options[:cookie])
      result.success?
    else
      Railway.pass!
    end
  end

  def alert_message!(options, **)
    options[:flash_alert] = "Game Create Error"
  end
end
