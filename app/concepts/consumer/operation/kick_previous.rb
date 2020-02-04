# Public: Operation to Destroy a Consumer if he rejoins with other ID.
#
# Examples
#
#     Consumer::Operation::KickPrevious.(
#       id: Consumer[:id]
#     )
#
# Returns a Trailblazer::Operation::Result object.
class Consumer::Operation::KickPrevious < Trailblazer::Operation
  step :present?, fast_track: true
  step :model!, fast_track: true
  step :check_consumer!, fast_track: true
  step :destroy!

  def present?(options, **)
    if options[:cookie].present?
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
    Consumer::Operation::Destroy.(id: model[:id])
  end
end