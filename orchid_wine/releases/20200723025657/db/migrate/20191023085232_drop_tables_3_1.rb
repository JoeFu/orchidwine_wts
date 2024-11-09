class DropTables31 < ActiveRecord::Migration[5.1]
  def change
    drop_table :productions
    drop_table :stacks
    drop_table :standards
    drop_table :stopper_images
    drop_table :order_pendings
    drop_table :order_pending_productions
    drop_table :order_delivery_productions
    drop_table :cap_images
    drop_table :bottle_service_prices
  end
end
