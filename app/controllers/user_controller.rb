class UserController < ActionController::Base
  def create
    result = User::Create.(params: params)
    
    if result.success?
      cookies.encrypted[:_pong_id] = result[:model].consumer.id
      redirect_to game_path(game_id: result[:model].game_id)
    else
      flash[:alert] = "User creation error"
      redirect_to new_user_path
    end
  end
end
