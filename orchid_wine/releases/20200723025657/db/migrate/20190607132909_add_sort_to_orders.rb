class AddSortToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :sort, :integer, :limit => 2, :default => 1
  end
end
