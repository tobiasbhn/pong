class ApplicationController < ActionController::Base
  include Pong::Helpers
  before_action :authenticate!, :check_password!, only: :show

  def index
    # TODO
  end

  def host
    # TODO
  end

  def join
    # TODO
  end

  def show
    consumer = Consumer.find(consumer_cookie)
  end


  private
  def authenticate!
    if authenticated?
      true
    else
      flash[:notice] = t('flash.notice.invite')
      redirect_to new_user_path(game_id: params[:game_id])
    end
  end

  def authenticated?
    id = consumer_cookie
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

  def check_password!
    game = Game.find(params[:game_id])
    if game.protect && protect_cookie != game.id
      render(html: cell(Page::Cell::Password, nil, id: game.id).(), layout: 'application', status: :ok)
    else
      true
    end
  end
end
