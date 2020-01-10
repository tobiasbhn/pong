class AddGameKeyToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :game_key, :string
  end
end
