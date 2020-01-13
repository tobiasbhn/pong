class ApplicationController < ActionController::Base
  include Pong::Helpers
  before_action :set_locale!

  def default_url_options
    { lang: I18n.locale }
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
        render_cell(
          page_cell: User::Cell::Auth,
          header_cell: User::Header::Cell::Auth
        )
      end
    else
      puts "Game not found".red
      false
    end
  end

  def render_cell(page_cell:, header_cell:, cell_object: nil, layout: 'application', status: :ok, **options)
    @html_head = header_cell
    render(html: cell(page_cell, cell_object, options).(), layout: layout, status: status)
  end

  def set_locale!
    lang = params[:lang]
    if lang.blank?
      puts "Applicationcontroller: before_action set_language: No language selected: Going to Auto-Select language and redirect".red
      redirect_to controller: params[:controller], action: params[:action], lang: auto_locale
    else
      puts "Applicationcontroller: before_action set_language: Selected Language: #{lang}".green
      I18n.locale = lang
    end
  end

  def auto_locale
    locales = request.env['HTTP_ACCEPT_LANGUAGE'] || I18n.default_locale
    locales.scan(/[a-z]{2}(?=;)/).find do |locale|
      I18n.available_locales.include?(locale.to_sym)
    end
  end
end
