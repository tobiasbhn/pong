class RenameConumerColumnClientCount < ActiveRecord::Migration[6.0]
  def change
    remove_column :consumers, :client_count, :integer
    add_column :consumers, :instance_count, :integer, default: 0
  end
end
