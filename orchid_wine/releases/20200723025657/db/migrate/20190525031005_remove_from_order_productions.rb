class RemoveFromOrderProductions < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_productions, :batch
    remove_column :order_productions, :container_number
    remove_column :order_productions, :boat_number
    remove_column :order_productions, :port
    remove_column :order_productions, :transport_status
  end
end
