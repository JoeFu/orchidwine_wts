class CreateOrderProductionTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table(:order_production_transitions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.integer :order_id
      t.integer :order_number
      t.integer :user_id

      t.integer :order_production_id
      t.integer :num

      t.integer :is_split, :default => 0, :limit => 2

      t.timestamps
    end
    add_index :order_production_transitions, :order_id
    add_index :order_production_transitions, :user_id
    add_index :order_production_transitions, :order_production_id
  end
end
