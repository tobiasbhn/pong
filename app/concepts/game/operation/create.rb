class Game::Create < Trailblazer::Operation
  step Model(Game, :new)
  step Contract::Build(constant: Game::Contract::Create)
  step :define_id!
  step :define_key!
  step Contract::Validate(key: :game)
  step Contract::Persist()
  pass :kick_old_consumer!

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
    # TODO: Kick old Consumer if still connected
    # if Consumer.exists?(id: cookies.encrypted[:_pong_id])
    #   Consumer::Destroy.(id: cookies.encrypted[:_pong_id])
    # end
    true
  end
end
