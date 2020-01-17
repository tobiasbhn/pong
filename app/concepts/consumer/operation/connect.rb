class Consumer::Operation::Connect < Trailblazer::Operation
  step :model!
  step :manipulate!
  step :save!

  def model!(options, **)
    puts "Consumer::Connect::Operation: model".tb
    options[:model] = Consumer.find_by(id: options[:id])
    options[:model].present?
  end

  def manipulate!(options, model:, **)
    puts "Consumer::Connect::Operation: manipulate".tb
    model.active = true
    model.instance_count += 1
    Railway.pass!
  end

  def save!(options, model:, **)
    puts "Consumer::Connect::Operation: save".tb
    model.save
  end
end