class UpdateOrderProductions < ActiveRecord::Migration[5.1][5.1]
  def change
    change_column :order_productions, :price, :float, :null => false, :default => 0
    change_column :order_productions, :unit_price, :float, :null => false, :default => 0
    change_column :order_productions, :fee, :float, :null => false, :default => 0
    change_column :order_productions, :production_num, :integer, :null => false, :default => 0
  end
end
