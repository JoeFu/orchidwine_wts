class AddNeedDeliveryToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :need_delivery, :integer, :limit => 2, :default => 1
  end
end
