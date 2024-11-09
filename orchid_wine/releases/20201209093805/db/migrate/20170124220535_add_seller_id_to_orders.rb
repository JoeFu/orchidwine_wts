class AddSellerIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :seller_id, :integer, :comment => '销售员id'
  end
end