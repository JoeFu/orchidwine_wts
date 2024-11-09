class AddCapPrintToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :cork_print, :integer, :limit => 2, :default => 0
    add_column :order_productions, :cap_print, :integer, :limit => 2, :default => 0

    add_column :order_delivery_productions, :cork_print, :integer, :limit => 2, :default => 0
    add_column :order_delivery_productions, :cap_print, :integer, :limit => 2, :default => 0
  end
end
