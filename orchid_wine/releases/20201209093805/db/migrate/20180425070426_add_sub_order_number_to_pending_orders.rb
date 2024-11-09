class AddSubOrderNumberToPendingOrders < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :pending_orders, :sub_order_number, :integer, :limit => 4, :default => 0
  end
end
