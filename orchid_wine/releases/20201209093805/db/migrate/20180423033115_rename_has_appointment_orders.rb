class RenameHasAppointmentOrders < ActiveRecord::Migration[5.1][5.1]
  def change
    rename_table :has_appointment_orders, :delivery_orders
    rename_table :has_appointment_order_productions, :delivery_order_productions
  end
end
