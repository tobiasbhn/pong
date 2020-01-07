class ApplicationController < ActionController::Base
  before_action :authenticate!, only: :show

  def index
    # TODO
  end

  def game
    # TODO
  end

  def user
    # TODO
  end

  def show
    # TODO
  end


  private
  def authenticated?
    id = cookies.encrypted[:_pong_id]
    if Consumer.exists?(id: id)
      consumer = Consumer.find(id)

      # check if connection to right game (is game_id in cookie == requested game_id)
      cookie_game_id = consumer.consumable_type == "Game" ? consumer.consumable.id : consumer.consumable.game_id
      request_game_id = params[:game_id].to_i
      
      cookie_game_id == request_game_id
    else
      false
    end
  end

  def authenticate!
    if authenticated?
      true
    else
      flash[:notice] = t('flash.notice.invite')
      redirect_to new_user_path(game_id: params[:game_id])
    end
  end
end
