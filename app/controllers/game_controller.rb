class GameController < ActionController::Base
  def create
    render plain: 'game#create'
  end
end
