class User::Create < Trailblazer::Operation
  step :check_game!
  step :check_key!
  fail :wrong_input!, fail_fast: true
  step Model(User, :new)
  step Contract::Build(constant: User::Contract::Create)
  step Contract::Validate(key: :user)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  def check_game!(options, params:, **)
    puts "User::Create::Operation: check_game".tb
    if Game.exists?(id: params[:user][:game_id])
      options[:game] = Game.find(params[:user][:game_id])
    else
      false
    end
  end

  def check_key!(options, game:, params:, **)
    puts "User::Create::Operation: check_key".tb
    game.key == params[:user][:game_key]
  end

  def wrong_input!(options, **)
    puts "User::Create::Operation: wrong_input".tb
    options[:flash_alert] = "Wrong Game Id or wrong Key."
  end

  def kick_old_consumer!(options, cookie:, **)
    puts "User::Create::Operation: kick_old_consumer".tb
    result = Consumer::KickPrevious.(cookie: cookie)
    result.success?
  end

  def alert_message!(options, **)
    puts "User::Create::Operation: alert_message".tb
    options[:flash_alert] = "User Create Error"
  end
end