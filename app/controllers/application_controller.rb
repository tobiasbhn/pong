class ApplicationController < ActionController::Base
  include Pong::Helpers
  before_action :authenticate!, :check_password!, only: :show

  def index
    # TODO
    puts "Using Controller Action: Application#Index".green
  end

  def host
    # TODO
    puts "Using Controller Action: Application#Host".green
  end

  def join
    # TODO
    puts "Using Controller Action: Application#Join".green
  end

  def show
    # TODO
    puts "Using Controller Action: Application#Show".green
  end


  private
  def authenticate!
    puts "User need to authenticate befor Action".green
    if authenticated?
      puts "User successfuly authenticated".green
      true
    elsif Game.exists?(id: params[:game_id])
      puts "User not authenticated but Game Exists, so hes probably invited".green
      flash[:notice] = t('flash.notice.invite')
      redirect_to new_user_path(game_id: params[:game_id])
    else
      puts "Game does not exist".red
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end

  def authenticated?
    cookie = consumer_cookie
    if Consumer.exists?(id: cookie&.[](:value))
      consumer = Consumer.find(cookie[:value])
      consumer_game_id = consumer.consumable_type == "Game" ? consumer.consumable.id : consumer.consumable.game_id

      # x.to_time to get the same Format (Thu, 09 Jan 2020 10:54:46 UTC +00:00 != "2020-01-09 10:54:46 UTC")
      # x.to_i to get rid of the milliseconds (1578567286.696185 != 1578567286.0)
      is_right_consumer = consumer.created_at.to_time.to_i == cookie[:time].to_time.to_i
      is_right_game = params[:game_id].to_i == consumer_game_id

      if !is_right_consumer
        puts "Could not authentiate User: Consumer found, but does not match expected Consumer".red
      end
      if !is_right_game
        puts "Could not authentiate User: Consumer found, but is not authenticated for this Game".red
      end

      is_right_consumer && is_right_game && Game.exists?(id: consumer_game_id)
    else
      puts "Could not authentiate User: Requested Consumer not found or no Cookie present".red
      false
    end
  end

  def check_password!
    game = Game.find_by(id: params[:game_id])
    cookie = protect_cookie
    if game.present? && !game.protect
      puts "Game is not Password-Protected".green
      true
    elsif game.present?
      if cookie&.[](:value) == game.id && cookie&.[](:time).to_time.to_i == game.created_at.to_time.to_i
        puts "Game is Password-Protected: User successfuly authenticated".green
        true
      else
        puts "Game is Password-Protected: User need to authenticate before".red
        render(html: cell(Page::Cell::Password, nil, id: game.id).(), layout: 'application', status: :ok)
      end
    else
      puts "Game not found".red
      false
    end
  end
end
