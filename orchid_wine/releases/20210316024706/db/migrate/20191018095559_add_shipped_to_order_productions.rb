class AddShippedToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :shipped, :integer, :default => 0, :limit => 2
  end
end
