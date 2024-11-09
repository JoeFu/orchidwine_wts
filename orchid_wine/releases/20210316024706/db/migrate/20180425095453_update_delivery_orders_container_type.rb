class UpdateDeliveryOrdersContainerType < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :delivery_orders, :container_type, :integer, :limit => 1, :default => 0
  end
end
