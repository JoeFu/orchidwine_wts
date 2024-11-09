class AddOceanDestNameToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :ocean_dest_name, :string, :comment => '目的港口'
  end
end
