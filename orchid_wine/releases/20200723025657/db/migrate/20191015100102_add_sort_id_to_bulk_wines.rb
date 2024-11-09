class AddSortIdToBulkWines < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wines, :sort_id, :integer, :default => 0
  end
end
