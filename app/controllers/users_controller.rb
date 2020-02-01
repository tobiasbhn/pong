class UsersController < ApplicationController
  def new
    Rails.logger.debug "Using Controller Action: Users#New".green
    Rails.logger.debug params.to_s.green
    result = User::Operation::Present.(params: params)

    if result.success?
      Rails.logger.debug "Users#New Operation success".green
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      Rails.logger.debug "Users#New Operation failure".red
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end
  
  def create
    Rails.logger.debug "Using Controller Action: Users#Create".green
    Rails.logger.debug params.to_s.green
    result = User::Operation::Create.(params: params, cookie: cookie_helper(name: "consumer"))
    
    if result.success?
      Rails.logger.debug "Users#Create Operation success".green
      cookie_helper(name: "consumer", model: result[:model].consumer)
      redirect_to game_path(game_id: result[:model].game_id)
    else
      Rails.logger.debug "Users#Create Operation failure".red
      Rails.logger.debug result['contract.default'].errors.messages.to_s.red
      flash[:alert] = "User creation error"
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    end
  end

  def auth
    Rails.logger.debug "Using Controller Action: Users#Auth".green
    Rails.logger.debug params.to_s.green
    game = Game.find_by(id: params[:game_id])
    if game&.authenticate(params[:password][:password])
      Rails.logger.debug "Game is Password-Protected: User successfully provided password".green
      cookie_helper(name: "protect", model: game)
      redirect_to game_path(game_id: game.id)
    elsif game.present?
      Rails.logger.debug "Game is Password-Protected: Provided Password wrong".red
      flash[:alert] = "Wrong Password."
      render_cell(
        page_cell: User::Cell::Auth,
        header_cell: User::Header::Cell::Auth
      )
    else
      Rails.logger.debug "Game does not exist".red
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end
end
