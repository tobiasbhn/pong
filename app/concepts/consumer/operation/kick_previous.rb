class Consumer::Operation::KickPrevious < Trailblazer::Operation
  step :present?, fast_track: true
  step :model!, fast_track: true
  step :check_consumer!, fast_track: true
  step :destroy!

  def present?(options, cookie:, **)
    if cookie.present?
      Railway.pass!
    else
      Railway.pass_fast!
    end
  end

  def model!(options, cookie:, **)
    if Consumer.exists?(id: cookie[:value])
      options[:model] = Consumer.find(cookie[:value])
      Railway.pass!
    else
      Railway.pass_fast!
    end
  end

  def check_consumer!(options, model:, cookie:, **)
    if cookie[:time].to_time.to_i == model.created_at.to_time.to_i
      Railway.pass!
    else
      Railway.pass_fast!
    end
  end

  def destroy!(options, model:, **)
    model.destroy
  end
end