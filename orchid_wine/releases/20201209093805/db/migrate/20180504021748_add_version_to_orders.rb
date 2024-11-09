class AddVersionToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :version, :integer, :default => 1, :limit => 3
  end
end
