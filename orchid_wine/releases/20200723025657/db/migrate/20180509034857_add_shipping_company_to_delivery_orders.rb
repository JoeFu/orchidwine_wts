class AddShippingCompanyToDeliveryOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :delivery_orders, :shipping_company, :string
    add_column :delivery_orders, :shipping_company_telephone, :string
  end
end
