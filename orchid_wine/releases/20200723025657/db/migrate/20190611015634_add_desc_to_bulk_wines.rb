class AddDescToBulkWines < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wines, :desc, :string
  end
end
