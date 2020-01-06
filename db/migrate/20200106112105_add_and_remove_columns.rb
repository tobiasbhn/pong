class AddAndRemoveColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :active, :boolean, default: false
    remove_column :consumers, :connections_count
  end
end
