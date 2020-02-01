# Public: Operation to increase the count of active Instances of a Consumer.
#
# Examples
#
#     Consumer::Operation::Connect.(
#       id: Consumer[:id]
#     )
#
# Returns a Trailblazer::Operation::Result object.
class Consumer::Operation::Connect < Trailblazer::Operation
  step :model!
  step :manipulate!
  step :save!

  def model!(options, **)
    Rails.logger.debug "Consumer::Connect::Operation: model".tb
    options[:model] = Consumer.find_by(id: options[:id])
    options[:model].present?
  end

  def manipulate!(options, model:, **)
    Rails.logger.debug "Consumer::Connect::Operation: manipulate".tb
    model.active = true
    model.instance_count += 1
    Railway.pass!
  end

  def save!(options, model:, **)
    Rails.logger.debug "Consumer::Connect::Operation: save".tb
    model.save
  end
end