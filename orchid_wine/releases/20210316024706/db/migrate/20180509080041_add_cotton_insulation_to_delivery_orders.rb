class AddCottonInsulationToDeliveryOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_orders, :cotton_insulation, :integer, :default => 0, :limit => 1
  end
end
