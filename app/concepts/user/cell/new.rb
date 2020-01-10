module User::Cell
  class New < Pong::Cell::Base
    def insert_game_id
      model&.input_params&.[](:game_id).presence || params[:game_id]
    end
  end
end