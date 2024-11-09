class AddCostToBulkWines < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wines, :cost, :float, :default => 0
  end
end
