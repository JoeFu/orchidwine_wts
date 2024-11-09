class AddContainerIdToOpds < ActiveRecord::Migration[5.1]
  def change
    add_column :order_production_deliveries, :container_id, :integer
    add_index :order_production_deliveries, :container_id
  end
end
