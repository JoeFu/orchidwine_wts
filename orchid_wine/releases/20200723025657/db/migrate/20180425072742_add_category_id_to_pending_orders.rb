class AddCategoryIdToPendingOrders < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :pending_orders, :category_id, :integer, :limit => 1, :default => 0
    add_column :pending_orders, :container_type, :integer, :limit => 1, :default => 0
  end
end
