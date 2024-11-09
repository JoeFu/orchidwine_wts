class AddIsHbToOrderProduction < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :is_hb, :integer, :default => 0
    add_column :order_pending_productions, :is_hb, :integer, :default => 0
    add_column :order_delivery_productions, :is_hb, :integer, :default => 0
  end
end
