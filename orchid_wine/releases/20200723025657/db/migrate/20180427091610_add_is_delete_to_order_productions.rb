class AddIsDeleteToOrderProductions < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :order_productions, :is_delete, :integer, :limit => 1, :default => 0
  end
end
