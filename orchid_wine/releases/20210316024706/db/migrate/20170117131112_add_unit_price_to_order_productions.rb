class AddUnitPriceToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :unit_price, :integer, :comment => '产品单价'
  end
end