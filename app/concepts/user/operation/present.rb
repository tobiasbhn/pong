class User::Present < Trailblazer::Operation
  step Model(User, :new)
  step Contract::Build(constant: User::Contract::Create)
end