class UpdateDeliveryOrderId < ActiveRecord::Migration[5.1][5.1]
  def change
    rename_column :delivery_order_productions, :has_appointment_order_id, :delivery_order_id
  end
end
