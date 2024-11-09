class AddPortOfLoadingToDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :port_of_loading, :string
    add_column :deliveries, :export_company_abn, :string
    rename_column :deliveries, :destination, :port_of_discharge
  end
end
