class Consumer::Operation::KickPrevious < Trailblazer::Operation
  step :present?, fast_track: true
  step :model!, fast_track: true
  step :check_consumer!, fast_track: true
  step :destroy!

  def present?(options, cookie:, **)
    puts "Consumer::KickPrevious::Operation: present".tb
    if cookie.present?
      puts "Consumer::KickPrevious::Operation: present: cookie present".tb
      Railway.pass!
    else
      puts "Consumer::KickPrevious::Operation: present: cookie not present".tb
      Railway.pass_fast!
    end
  end

  def model!(options, cookie:, **)
    puts "Consumer::KickPrevious::Operation: model".tb
    if Consumer.exists?(id: cookie[:value])
      puts "Consumer::KickPrevious::Operation: model: Consumer exists".tb
      options[:model] = Consumer.find(cookie[:value])
      Railway.pass!
    else
      puts "Consumer::KickPrevious::Operation: model: Consumer doesnt exist".tb
      Railway.pass_fast!
    end
  end

  def check_consumer!(options, model:, cookie:, **)
    puts "Consumer::KickPrevious::Operation: check_consumer".tb
    if cookie[:time].to_time.to_i == model.created_at.to_time.to_i
      puts "Consumer::KickPrevious::Operation: check_consumer: Consumer will be deleted".tb
      Railway.pass!
    else
      puts "Consumer::KickPrevious::Operation: check_consumer: Consumer will remain in db".tb
      Railway.pass_fast!
    end
  end

  def destroy!(options, model:, **)
    puts "Consumer::KickPrevious::Operation: destroy".tb
    model.destroy
  end
end