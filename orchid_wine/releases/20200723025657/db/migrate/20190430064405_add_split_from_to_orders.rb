class AddSplitFromToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :split_from, :integer
  end
end
