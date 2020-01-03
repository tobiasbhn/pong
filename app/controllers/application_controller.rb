class ApplicationController < ActionController::Base
  before_action :authenticate!, only: :show

  def index
    
  end

  def game

  end

  def user

  end

  def show
    
  end

  private

  def authenticated?
    id = cookies.encrypted[:id]
    if Consumer.exists?(id: id)
      consumer = Consumer.find(id)
      game_id = consumer.consumable_type == "Game" ? consumer.consumable.id : consumer.consumable.game_id
      game_id == params[:game_id].to_i
    else
      false
    end
  end

  def authenticate!
    if authenticated?
      true
    else
      flash[:alert] = "Something went wrong."
      redirect_to index_path
    end
  end
end
