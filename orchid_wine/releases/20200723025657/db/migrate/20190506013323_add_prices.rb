class AddPrices < ActiveRecord::Migration[5.1]
  def change
    add_column :caps, :price, :float, :default => 0
    add_column :cartons, :price, :float, :default => 0
    add_column :dividers, :price, :float, :default => 0
    add_column :bottles, :price, :float, :default => 0
    add_column :origins, :price, :float, :default => 0
    add_column :corks, :price, :float, :default => 0
  end
end
