class AddBottleCustomizeToBulkWineStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wine_stocks, :bottle_customize, :integer, :limit => 2, :default => 0
  end
end
