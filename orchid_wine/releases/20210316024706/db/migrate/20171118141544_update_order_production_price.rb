class UpdateOrderProductionPrice < ActiveRecord::Migration[5.1]
  def change
  	change_column :order_productions, :unit_price, :float
  	change_column :order_productions, :price, :float
  	change_column :order_productions, :production_num, :integer
  	change_column :order_productions, :fee, :float
  	change_column :orders, :total_price, :float
  	change_column :orders, :product_price, :float
  end
end
