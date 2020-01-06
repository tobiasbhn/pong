class MoveActiveToConsumer < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :active
    remove_column :games, :active
    add_column :consumers, :active, :boolean, default: false
  end
end
