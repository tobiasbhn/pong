class RemoveProtectedBoolFromGame < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :protect, :boolean
  end
end
