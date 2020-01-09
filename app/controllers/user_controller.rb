class UserController < ActionController::Base
  include Pong::Helpers

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
      redirect_to new_user_path # TODO: irgendwie contract.default mit geben
    end
  end

  def auth
    puts "Using Controller Action: User#Auth".green
    game = Game.find_by(id: params[:password][:id])
    if game&.authenticate(params[:password][:password])
      puts "Game is Password-Protected: User successfully provided password".green
      protect_cookie(game)
      redirect_to game_path(game_id: game.id)
    elsif game.present?
      puts "Game is Password-Protected: Provided Password wrong".red
      flash[:alert] = "Wrong Password."
      render(html: cell(Page::Cell::Password, nil, id: game.id).(), layout: 'application', status: :ok)
    else
      puts "Game does not exist".red
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end
end
