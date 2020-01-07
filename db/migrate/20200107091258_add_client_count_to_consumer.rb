class AddClientCountToConsumer < ActiveRecord::Migration[6.0]
  def change
    add_column :consumers, :client_count, :integer, default: 0
  end
end
