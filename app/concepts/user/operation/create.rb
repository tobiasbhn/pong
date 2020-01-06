class User::Create < Trailblazer::Operation
  step :check_game!
  step :check_key!
  fail :wrong_input!, fail_fast: true
  step Model(User, :new)
  step Contract::Build(constant: User::Contract::Create)
  step Contract::Validate(key: :user)
  step Contract::Persist()
  pass :kick_old_consumer!
  fail :alert_message!

  def check_game!(options, params:, **)
    if Game.exists?(id: params[:user][:game_id])
      options[:game] = Game.find(params[:user][:game_id])
    else
      false
    end
  end

  def check_key!(options, game:, params:, **)
    game.key == params[:user][:game_key]
  end

  def wrong_input!(options, **)
    options[:flash_alert] = "Wrong Game Id or wrong Key."
  end

  def kick_old_consumer!(options, **)
    # TODO: Kick old Consumer if still connected
    # if Consumer.exists?(id: cookies.encrypted[:_pong_id])
    #   Consumer::Destroy.(id: cookies.encrypted[:_pong_id])
    # end
    true
  end

  def alert_message!(options, **)
    options[:flash_alert] = "User Create Error"
  end
end