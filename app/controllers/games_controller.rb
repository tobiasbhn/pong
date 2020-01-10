class GamesController < ApplicationController
  def create
    puts "Using Controller Action: Game#Create".green
    result = Game::Create.(params: params, cookie: consumer_cookie)
    
    if result.success?
      puts "Game#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      protect_cookie(result[:model]) if result[:model].protect
      redirect_to game_path(game_id: result[:model].id)
    else
      puts "Game#Create Operation failure".red
      flash[:alert] = "Game creation error"
      render_cell(
        page_cell: Page::Cell::Host,
        header_cell: Head::Cell::Host,
        cell_object: result['contract.default']
      )
    end
  end
end
