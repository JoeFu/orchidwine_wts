class AddTotalBottleNumToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :total_bottle_num, :integer, :comment => '总瓶数'
  end
end