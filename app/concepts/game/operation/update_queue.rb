class Game::Operation::UpdateQueue < Trailblazer::Operation
  step :model!
  step :check_mode!, fast_track: true
  step :users!, fast_track: true
  
  def model!(options, id:, **)
    options[:model] = Game.find_by(id: id)
    options[:model].present?
  end

  def check_mode!(options, model:, **)
    if model.mode == 'party'
      Railway.pass!
    else
      Railway.pass_fast!
    end
  end

  def users!(options, model:, **)
    options[:users] = model.users
    if options[:users].count == 0
      Railway.pass_fast!
    else
      Railway.pass!
    end
  end
end