class GamesController < ApplicationController
  before_action :authenticate!, :check_password!, only: :show

  def new
    Rails.logger.debug "Using Controller Action: Games#New".green
    Rails.logger.debug params.to_s.green
    result = Game::Operation::Present.(params: params)

    if result.success?
      Rails.logger.debug "Games#New Operation success".green
      render_cell(
        page_cell: Game::Cell::New,
        header_cell: Game::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      Rails.logger.debug "Games#New Operation failure".red
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end

  def create
    Rails.logger.debug "Using Controller Action: Games#Create".green
    Rails.logger.debug params.to_s.green
    result = Game::Operation::Create.(params: params, cookie: consumer_cookie)

    if result.success?
      Rails.logger.debug "Games#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      protect_cookie(result[:model]) if result[:model].protect
      redirect_to game_path(game_id: result[:model].id)
    else
      Rails.logger.debug "Games#Create Operation failure".red
      flash[:alert] = "Game creation error"
      render_cell(
        page_cell: Game::Cell::New,
        header_cell: Game::Header::Cell::New,
        cell_object: result['contract.default']
      )
    end
  end

  def show
    # TODO: dynamicly select which cell depending on game mode and consumer type
    Rails.logger.debug "Using Controller Action: Games#Show".green
    Rails.logger.debug params.to_s.green
    render_cell(
      page_cell: Game::Cell::Show,
      header_cell: Game::Header::Cell::Show
    )
  end
end
