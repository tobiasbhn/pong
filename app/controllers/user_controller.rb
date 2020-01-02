class UserController < ActionController::Base
  def create
    render plain: 'user#create'
  end
end
