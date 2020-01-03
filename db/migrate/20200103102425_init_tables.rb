class InitTables < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :key
      t.string :mode
      t.timestamps
    end
     
    create_table :users do |t|
      t.belongs_to :game
      t.string :name
      t.integer :queue
      t.timestamps
    end
    
    create_table :consumers do |t|
      t.references :consumable, polymorphic: true
      t.integer :connections_count, default: 0
      t.timestamps
    end
  end
end
