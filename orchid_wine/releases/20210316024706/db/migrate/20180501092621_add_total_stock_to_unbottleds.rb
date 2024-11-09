class AddTotalStockToUnbottleds < ActiveRecord::Migration[5.1]
  def change
    add_column :unbottleds, :total_stock, :integer, :default => 0
  end
end
