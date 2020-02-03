class Consumer::Operation::Disconnect < Trailblazer::Operation
  step :model!
  step :manipulate!
  step :save!

  def model!(options, **)
    options[:model] = Consumer.find_by(id: options[:id])
    options[:model].present?
  end

  def manipulate!(options, model:, **)
    model.instance_count -= 1
    model.active = false if model.instance_count <= 0
    Railway.pass!
  end

  def save!(options, model:, **)
    model.save
  end
end