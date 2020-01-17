class AddEnqueueTimeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :enqueued_at, :datetime, precision: 6
    remove_column :users, :queue, :integer
    add_column :users, :queue_pos, :integer
  end
end
