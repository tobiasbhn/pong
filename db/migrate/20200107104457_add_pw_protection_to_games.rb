class AddPwProtectionToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :protect, :boolean, default: false
    add_column :games, :password_digest, :string
  end
end
