class Consumer::Operation::KickPrevious < Trailblazer::Operation
  step :present?, fast_track: true
  step :model!, fast_track: true
  step :check_consumer!, fast_track: true
  step :destroy!

  def present?(options, cookie:, **)
    Rails.logger.debug "Consumer::KickPrevious::Operation: present".tb
    if cookie.present?
      Rails.logger.debug "Consumer::KickPrevious::Operation: present: cookie present".tb
      Railway.pass!
    else
      Rails.logger.debug "Consumer::KickPrevious::Operation: present: cookie not present".tb
      Railway.pass_fast!
    end
  end

  def model!(options, cookie:, **)
    Rails.logger.debug "Consumer::KickPrevious::Operation: model".tb
    if Consumer.exists?(id: cookie[:value])
      Rails.logger.debug "Consumer::KickPrevious::Operation: model: Consumer exists".tb
      options[:model] = Consumer.find(cookie[:value])
      Railway.pass!
    else
      Rails.logger.debug "Consumer::KickPrevious::Operation: model: Consumer doesnt exist".tb
      Railway.pass_fast!
    end
  end

  def check_consumer!(options, model:, cookie:, **)
    Rails.logger.debug "Consumer::KickPrevious::Operation: check_consumer".tb
    if cookie[:time].to_time.to_i == model.created_at.to_time.to_i
      Rails.logger.debug "Consumer::KickPrevious::Operation: check_consumer: Consumer will be deleted".tb
      Railway.pass!
    else
      Rails.logger.debug "Consumer::KickPrevious::Operation: check_consumer: Consumer will remain in db".tb
      Railway.pass_fast!
    end
  end

  def destroy!(options, model:, **)
    Rails.logger.debug "Consumer::KickPrevious::Operation: destroy".tb
    model.destroy
  end
end