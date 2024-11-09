class RenameOriginToBulkWine < ActiveRecord::Migration[5.1]
  def change
    rename_table :origins, :bulk_wines

    rename_column :bulk_wines, :origin_code, :code

    rename_column :unbottleds, :origin_id, :bulk_wine_id
    
    rename_column :productions, :origin_id, :bulk_wine_id
    rename_column :productions, :origin_code, :bulk_wine_code
    rename_column :productions, :origin_desc, :bulk_wine_desc

    rename_column :order_productions, :origin_id, :bulk_wine_id
    rename_column :order_productions, :origin_code, :bulk_wine_code
    rename_column :order_productions, :origin_desc, :bulk_wine_desc

    rename_column :pending_order_productions, :origin_id, :bulk_wine_id
    rename_column :pending_order_productions, :origin_code, :bulk_wine_code
    rename_column :pending_order_productions, :origin_desc, :bulk_wine_desc

    rename_column :delivery_order_productions, :origin_id, :bulk_wine_id
    rename_column :delivery_order_productions, :origin_code, :bulk_wine_code
    rename_column :delivery_order_productions, :origin_desc, :bulk_wine_desc
  end
end
