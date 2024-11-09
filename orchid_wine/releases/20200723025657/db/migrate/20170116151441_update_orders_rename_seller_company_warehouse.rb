class UpdateOrdersRenameSellerCompanyWarehouse < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :seller_copmany_warehouse, :seller_company_warehouse
  end
end