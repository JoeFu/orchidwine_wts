class AddAutoConfirmToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :auto_confirm, :integer, :default => 0, :limit => 2
  end
end
