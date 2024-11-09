class AddCapPrintToBulkWineStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wine_stocks, :cork_print, :integer, :limit => 2, :default => 0
    add_column :bulk_wine_stocks, :cap_print, :integer, :limit => 2, :default => 0
  end
end
