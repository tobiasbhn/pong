class User::Operation::Create < Trailblazer::Operation
  step Subprocess(User::Operation::Present)
  step :check_username!
  step Contract::Validate(key: :user)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  def check_username!(options, params:, **)
    Rails.logger.debug "User::Create::Operation: check_username".tb
    if params[:user][:name].blank?
      params[:user][:name] = "noname"
    else
      Railway.pass!
    end
  end

  def kick_old_consumer!(options, cookie:, **)
    Rails.logger.debug "User::Create::Operation: kick_old_consumer".tb
    result = Consumer::Operation::KickPrevious.(cookie: cookie)
    result.success?
  end

  def alert_message!(options, **)
    Rails.logger.debug "User::Create::Operation: alert_message".tb
    options[:flash_alert] = "User Create Error"
  end
end