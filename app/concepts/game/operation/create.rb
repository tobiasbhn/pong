class Game::Operation::Create < Trailblazer::Operation
  step Subprocess(Game::Operation::Present)
  step :define_id!
  step :define_key!
  step Contract::Validate(key: :game)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  def define_id!(options, params:, **)
    Rails.logger.debug "Game::Create::Operation: define_id".tb
    params[:game][:id]
    while params[:game][:id].nil?
      id = rand(10000..99999)
      params[:game][:id] = id unless Game.exists?(id: id)
    end
    params[:game][:id].present?
  end

  def define_key!(options, params:, **)
    Rails.logger.debug "Game::Create::Operation: define_key".tb
    num_space = ('2'..'9').to_a
    char_space = ('a'..'h').to_a + ('j'..'k').to_a + ('m'..'z').to_a
    cap_space = ('A'..'H').to_a + ('J'..'K').to_a + ('M'..'Z').to_a
    params[:game][:key] = (num_space + char_space + cap_space).shuffle.first(5).join
    params[:game][:key].present?
  end

  def kick_old_consumer!(options, cookie:, **)
    Rails.logger.debug "Game::Create::Operation: kick_old_consumer".tb
    result = Consumer::Operation::KickPrevious.(cookie: cookie)
    result.success?
  end

  def alert_message!(options, **)
    Rails.logger.debug "Game::Create::Operation: alert_message".tb
    options[:flash_alert] = "Game Create Error"
  end
end
