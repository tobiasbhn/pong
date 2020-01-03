class AddActiveScopeToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :active, :boolean, default: false
  end
end
