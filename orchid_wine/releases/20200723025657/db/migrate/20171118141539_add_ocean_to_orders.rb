class AddOceanToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :ocean_start_id, :integer, :comment => '起运港口'
    add_column :orders, :ocean_dest_id, :integer, :comment => '目的港口'
    add_column :orders, :ocean_insurance, :integer, :comment => '海运保险'
    add_column :orders, :ocean_assign, :integer, :comment => '海运承运方'
    add_column :orders, :ocean_felt, :integer, :comment => '隔热棉要求'
    
    add_column :orders, :ocean_company_name, :string, :comment => '公司名称'
    add_column :orders, :ocean_company_contacts, :string, :comment => '联系人'
    add_column :orders, :ocean_company_telephone, :string, :comment => '电话'
    add_column :orders, :ocean_company_email, :string, :comment => '电子邮箱'
  end
end

