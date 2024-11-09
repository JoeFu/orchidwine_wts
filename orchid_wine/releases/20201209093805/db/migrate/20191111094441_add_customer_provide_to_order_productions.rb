class AddCustomerProvideToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :bottle_provider, :integer, :limit => 1, :default => 0
    add_column :order_productions, :bottle_customize, :integer, :limit => 2, :default => 0
    add_column :order_productions, :cork_provider, :integer, :limit => 1, :default => 0
    add_column :order_productions, :cap_provider, :integer, :limit => 1, :default => 0
    add_column :order_productions, :divider_provider, :integer, :limit => 1, :default => 0
    add_column :order_productions, :carton_provider, :integer, :limit => 1, :default => 0
  end
end
