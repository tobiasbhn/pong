class ApplicationController < ActionController::Base
  def index
    
  end

  def show
    render plain: 'application#show: ' + params[:game_id]
  end
end
