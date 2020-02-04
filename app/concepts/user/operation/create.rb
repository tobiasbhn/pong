# Public: Operation to create a User.
#
#   User::Operation::Create.(
#     params: {
#       user: {
#         name: 'Tobi',
#         game_id: '12345',
#         game_key: 'f43g4',
#         legal: '1'
#       },
#       cookie: cookie
#     }
#   )
#
# Returns a Trailblazer::Operation::Result object.
class User::Operation::Create < Trailblazer::Operation
  step Subprocess(User::Operation::Present)
  step :check_username!
  step Contract::Validate(key: :user)
  step :kick_old_consumer!
  step Contract::Persist()
  fail :alert_message!

  def check_username!(options, params:, **)
    if params[:user][:name].blank?
      params[:user][:name] = "noname"
    else
      Railway.pass!
    end
  end

  def kick_old_consumer!(options, **)
    result = Consumer::Operation::KickPrevious.(cookie: options[:cookie])
    result.success?
  end

  def alert_message!(options, **)
    options[:flash_alert] = "User Create Error"
  end
end