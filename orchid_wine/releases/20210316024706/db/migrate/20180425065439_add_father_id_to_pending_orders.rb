class AddFatherIdToPendingOrders < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :pending_orders, :father_id, :integer
  end
end
