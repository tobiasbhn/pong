class UsersController < ApplicationController
  def new
    result = User::Operation::Present.(params: params)

    if result.success?
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    else
      flash[:alert] = "Something went wrong"
      redirect_to index_path
    end
  end
  
  def create
    result = User::Operation::Create.(params: params, cookie: cookie_helper(name: "consumer"))
    
    if result.success?
      cookie_helper(name: "consumer", model: result[:model].consumer)
      redirect_to game_path(game_id: result[:model].game_id)
    else
      flash[:alert] = "User creation error"
      render_cell(
        page_cell: User::Cell::New,
        header_cell: User::Header::Cell::New,
        cell_object: result['contract.default']
      )
    end
  end

  def auth
    game = Game.find_by(id: params[:game_id])
    if game&.authenticate(params[:password][:password])
      cookie_helper(name: "protect", model: game)
      redirect_to game_path(game_id: game.id)
    elsif game.present?
      flash[:alert] = "Wrong Password."
      render_cell(
        page_cell: User::Cell::Auth,
        header_cell: User::Header::Cell::Auth
      )
    else
      flash[:alert] = "Game not found."
      redirect_to index_path
    end
  end
end
