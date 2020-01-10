class User::Operation::Create < Trailblazer::Operation
  step Subprocess(User::Operation::Present)
  # step :check_game!
  # step :check_key!
  step :check_username!
  step Contract::Validate(key: :user)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  # def check_game!(options, params:, **)
  #   puts "User::Create::Operation: check_game".tb
  #   if Game.exists?(id: params[:user][:game_id])
  #     options[:game] = Game.find(params[:user][:game_id])
  #   else
  #     options['contract.default'].errors.add(:game_id, 'Game Id oder Key falsch')
  #     # options['contract.default'].errors.add(:game_key, 'Game Id oder Key falsch')
  #     Railway.fail!
  #   end
  # end

  # def check_key!(options, game:, params:, **)
  #   puts "User::Create::Operation: check_key".tb
  #   if game.key == params[:user][:game_key]
  #     Railway.pass!
  #   else
  #     # options['contract.default'].errors.add(:game_id, 'Game Id oder Key falsch')
  #     options['contract.default'].errors.add(:game_key, 'Game Id oder Key falsch')
  #     Railway.fail!
  #   end
  # end

  def check_username!(options, params:, **)
    puts "User::Create::Operation: check_username".tb
    if params[:user][:name].blank?
      params[:user][:name] = "noname"
    else
      Railway.pass!
    end
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