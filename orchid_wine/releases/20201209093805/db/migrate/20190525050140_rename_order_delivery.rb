class RenameOrderDelivery < ActiveRecord::Migration[5.1]
  def change
    rename_table :order_deliveries, :deliveries
  end
end
