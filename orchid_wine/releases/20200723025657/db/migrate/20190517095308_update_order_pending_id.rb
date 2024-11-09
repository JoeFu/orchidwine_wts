class UpdateOrderPendingId < ActiveRecord::Migration[5.1]
  def change
    rename_column :order_pending_productions, :pending_order_id, :order_pending_id
    rename_column :order_delivery_productions, :delivery_order_id, :order_delivery_id
  end
end
