class ApplicationController < ActionController::Base
  include Pong::Helpers
  before_action :set_locale!

  def default_url_options
    { lang: I18n.locale }
  end

  private
  def authenticate!
    if authenticated?
      true
    elsif Game.exists?(id: params[:game_id])
      flash[:notice] = t('flash.notice.invite')
      redirect_to new_user_path(game_id: params[:game_id])
    else
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end

  def authenticated?
    cookie = cookie_helper(name: "consumer")
    if Consumer.exists?(id: cookie&.[](:value))
      consumer = Consumer.find(cookie[:value])
      consumer_game_id = consumer.consumable[:game_id].presence || consumer.consumable[:id]

      # x.to_time to get the same Format (Thu, 09 Jan 2020 10:54:46 UTC +00:00 != "2020-01-09 10:54:46 UTC")
      # x.to_i to get rid of the milliseconds (1578567286.696185 != 1578567286.0)
      is_right_consumer = consumer.created_at.to_time.to_i == cookie[:time].to_time.to_i
      is_right_game = params[:game_id].to_i == consumer_game_id

      is_right_consumer && is_right_game && Game.exists?(id: consumer_game_id)
    else
      false
    end
  end

  def check_password!
    game = Game.find_by(id: params[:game_id])
    cookie = cookie_helper(name: "protect")
    if game.present? && !game.protect
      true
    elsif game.present?
      if cookie&.[](:value) == game.id && cookie&.[](:time).to_time.to_i == game.created_at.to_time.to_i
        true
      else
        render_cell(
          page_cell: User::Cell::Auth,
          header_cell: User::Header::Cell::Auth
        )
      end
    else
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
      redirect_to controller: params[:controller], action: params[:action], lang: auto_locale
    else
      I18n.locale = lang
    end
  end

  def auto_locale
    locales = request.env['HTTP_ACCEPT_LANGUAGE']
    selected_locale = I18n.default_locale
    locales.to_s.scan(/[a-z]{2}(?=;)/).find do |locale|
      if I18n.available_locales.include?(locale.to_sym)
        selected_locale = locale.to_sym
      end
    end
    selected_locale
  end
end
