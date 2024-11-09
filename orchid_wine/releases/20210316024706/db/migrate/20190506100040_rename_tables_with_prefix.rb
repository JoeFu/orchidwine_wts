class RenameTablesWithPrefix < ActiveRecord::Migration[5.1]
  def change
    rename_table :vendors, :bulk_wine_vendors

    rename_table :unbottleds, :bulk_wine_stocks

    rename_table :unbottled_stock_logs, :bulk_wine_stock_logs
    rename_column :bulk_wine_stock_logs, :origin_id, :bulk_wine_id
    remove_column :bulk_wine_stock_logs, :unbottled_id

    # rename_table :bottle_service_prices, :packaging_bottle_service_prices
    # rename_table :bottles, :packaging_bottles
    # rename_table :cap_colors, :packaging_cap_colors
    # rename_table :caps, :packaging_caps
    # rename_table :cartons, :packaging_cartons
    # rename_table :corks, :packaging_corks
    # rename_table :dividers, :packaging_dividers

    rename_table :delivery_order_productions, :order_delivery_productions
    rename_table :delivery_orders, :order_deliveries
    # rename_table :order_productions, :order_productions
    # rename_table :order_records, :order_records
    rename_table :pending_order_productions, :order_pending_productions
    rename_table :pending_orders, :order_pendings

    # drop_table :wine_labels
    # drop_table :standards
    # drop_table :stacks
    # drop_table :stopper_images
    # drop_table :cap_images
  end
end
