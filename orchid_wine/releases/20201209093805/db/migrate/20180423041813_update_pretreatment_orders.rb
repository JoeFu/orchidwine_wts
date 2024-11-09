class UpdatePretreatmentOrders < ActiveRecord::Migration[5.1][5.1]
  def change

    rename_table :pretreatment_orders, :pending_orders
    rename_table :pretreatment_order_productions, :pending_order_productions
    rename_column :pending_order_productions, :pretreatment_order_id, :pending_order_id

    rename_table :wait_appointment_orders, :processed_orders
    rename_table :wait_appointment_order_productions, :processed_order_productions
    rename_column :processed_order_productions, :wait_appointment_order_id, :processed_order_id

  end
end
