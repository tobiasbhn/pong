class User::Destroy < Trailblazer::Operation
  step :model!
  step :destroy!

  def model!(options, **)

  end

  def destroy!(options, model:, **)

  end
end