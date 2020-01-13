class UsersController < ApplicationController
  def new
    puts "Using Controller Action: Users#New".green
    puts params.to_s.green
    result = User::Operation::Present.(params: params)

    if result.success?
      puts "Users#New Operation success".green
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      puts "Users#New Operation failure".red
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end
  
  def create
    puts "Using Controller Action: Users#Create".green
    puts params.to_s.green
    result = User::Operation::Create.(params: params, cookie: consumer_cookie)
    
    if result.success?
      puts "Users#Create Operation success".green
      consumer_cookie(result[:model].consumer)
      redirect_to game_path(game_id: result[:model].game_id)
    else
      puts "Users#Create Operation failure".red
      puts result['contract.default'].errors.messages.to_s.red
      flash[:alert] = "User creation error"
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    end
  end

  def auth
    puts "Using Controller Action: Users#Auth".green
    puts params.to_s.green
    game = Game.find_by(id: params[:game_id])
    if game&.authenticate(params[:password][:password])
      puts "Game is Password-Protected: User successfully provided password".green
      protect_cookie(game)
      redirect_to game_path(game_id: game.id)
    elsif game.present?
      puts "Game is Password-Protected: Provided Password wrong".red
      flash[:alert] = "Wrong Password."
      render_cell(
        page_cell: User::Cell::Auth,
        header_cell: User::Header::Cell::Auth
      )
    else
      puts "Game does not exist".red
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end
end
