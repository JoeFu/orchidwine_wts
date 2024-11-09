class CreateOrderProductionDeliveries < ActiveRecord::Migration[5.1]
  def change
    create_table(:order_production_deliveries, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.integer :delivery_id
      t.integer :order_id
      t.integer :order_number
      t.integer :user_id
      t.integer :order_production_id
      t.integer :num
      t.integer :is_split, :default => 0, :limit => 2
      
      t.timestamps
    end
    add_index :order_production_deliveries, :delivery_id
    add_index :order_production_deliveries, :order_id
    add_index :order_production_deliveries, :user_id
    add_index :order_production_deliveries, :order_production_id
  end
end
