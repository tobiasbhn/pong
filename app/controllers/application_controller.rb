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

      # check if connection to right game
      game_id = consumer.consumable_type == "Game" ? consumer.consumable.id : consumer.consumable.game_id
      if !(game_id == params[:game_id].to_i)
        flash[:alert] = "Wrong Game."
        return false
      end
      true
    else
      flash[:alert] = "No Cookie."
      false
    end
  end

  def authenticate!
    if authenticated?
      true
    else
      redirect_to index_path
    end
  end
end
