class AddToDeliverToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :to_deliver, :integer, :limit => 2, :default => 1, :comment => '是否删除 1-否 2-是'
  end
end