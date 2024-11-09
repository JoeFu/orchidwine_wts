class AddClearanceDeliveryWharfToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :clearance_delivery_wharf, :string, :comment => '清关公司交货码头'
    add_column :orders, :price_explain, :text, :comment => '报价说明'
  end
end