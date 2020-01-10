class UsersController < ApplicationController
  def new

  end
  
  def create
    puts "Using Controller Action: User#Create".green
    result = User::Create.(params: params, cookie: consumer_cookie)
    
    if result.success?
      puts "User#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      redirect_to game_path(game_id: result[:model].game_id)
    else
      puts "User#Create Operation failure".red
      flash[:alert] = "User creation error"
      render_cell(
        page_cell: Page::Cell::Join,
        header_cell: Head::Cell::Join,
        cell_object: result['contract.default']
      )
    end
  end

  def auth
    puts "Using Controller Action: User#Auth".green
    game = Game.find_by(id: params[:game_id])
    if game&.authenticate(params[:password][:password])
      puts "Game is Password-Protected: User successfully provided password".green
      protect_cookie(game)
      redirect_to game_path(game_id: game.id)
    elsif game.present?
      puts "Game is Password-Protected: Provided Password wrong".red
      flash[:alert] = "Wrong Password."
      render_cell(page_cell: Page::Cell::Password)
    else
      puts "Game does not exist".red
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end
end
