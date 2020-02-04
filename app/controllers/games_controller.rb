class GamesController < ApplicationController
  before_action :authenticate!, :check_password!, only: :show

  def new
    result = Game::Operation::Present.(params: params)

    if result.success?
      render_cell(
        page_cell: Game::Cell::New,
        header_cell: Game::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end

  def create
    result = Game::Operation::Create.(params: params, cookie: cookie_helper(name: "consumer"))

    if result.success?
      cookie_helper(name: "consumer", model: result[:model].consumer)
      cookie_helper(name: "protect", model: result[:model]) if result[:model].password_digest.present?
      redirect_to game_path(game_id: result[:model].id)
    else
      flash[:alert] = "Game creation error"
      render_cell(
        page_cell: Game::Cell::New,
        header_cell: Game::Header::Cell::New,
        cell_object: result['contract.default']
      )
    end
  end

  def show
    render_cell(
      page_cell: Game::Cell::Show,
      header_cell: Game::Header::Cell::Show
    )
  end
end
