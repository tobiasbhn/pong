class GamesController < ApplicationController
  before_action :authenticate!, :check_password!, only: :show

  def new
    puts "Using Controller Action: Games#New".green
    result = Game::Operation::Present.(params: params)

    if result.success?
      puts "Games#New Operation success".green
      render_cell(
        page_cell: Game::Cell::New,
        header_cell: Game::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      puts "Games#New Operation failure".red
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end

  def create
    puts "Using Controller Action: Games#Create".green
    result = Game::Operation::Create.(params: params, cookie: consumer_cookie)

    if result.success?
      puts "Games#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      protect_cookie(result[:model]) if result[:model].protect
      redirect_to game_path(game_id: result[:model].id)
    else
      puts "Games#Create Operation failure".red
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
    puts "Using Controller Action: Games#Show".green
    render_cell(
      page_cell: Game::Cell::Show,
      header_cell: Game::Header::Cell::Show
    )
  end
end
