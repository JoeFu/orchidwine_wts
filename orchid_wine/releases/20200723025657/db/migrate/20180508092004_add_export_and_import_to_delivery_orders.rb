class AddExportAndImportToDeliveryOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_orders, :export_company_name, :string
    add_column :delivery_orders, :export_company_contacts, :string
    add_column :delivery_orders, :export_company_telephone, :string
    add_column :delivery_orders, :export_company_email, :string
    add_column :delivery_orders, :export_company_address, :string
    add_column :delivery_orders, :import_company_name, :string
    add_column :delivery_orders, :import_company_contacts, :string
    add_column :delivery_orders, :import_company_telephone, :string
    add_column :delivery_orders, :import_company_email, :string
    add_column :delivery_orders, :import_company_address, :string
  end
end
