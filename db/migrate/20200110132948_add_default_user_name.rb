class AddDefaultUserName < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :name
    add_column :users, :name, :string, default: 'noname'
  end
end
