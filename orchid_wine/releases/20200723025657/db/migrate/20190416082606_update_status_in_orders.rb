class UpdateStatusInOrders < ActiveRecord::Migration[5.1]
  def change
  	change_column :orders, :status, :integer, :limit => 2, :default => 0
  end
end
