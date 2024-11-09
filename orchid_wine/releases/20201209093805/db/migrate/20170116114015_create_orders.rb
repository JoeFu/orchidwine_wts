# encoding: utf-8
# 订单表
class CreateOrders  < ActiveRecord::Migration[5.1]
    def change
        create_table(:orders, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
            t.integer :user_id,:comment => '用户ID'
            t.string  :order_number, :comment => '订单编号'
            t.integer :delivery_way_id, :comment => '交付方式ID'
            t.string  :delivery_way, :comment => '交付方式'

            t.string  :export_company_name, :comment=>'出口公司名称'
            t.string  :export_company_address, :comment=>'出口公司地址'
            t.string  :export_company_contacts, :comment=>'出口公司联系人'
            t.string  :export_company_email, :comment => '出口公司邮箱'
            t.string  :export_company_telephone, :comment=>'出口公司电话'

            t.string  :clearance_company_name, :comment => '清关公司名称'
            t.string  :clearance_company_address,:comment => '清关公司地址'
            t.string  :clearance_company_contacts,:comment => '清关公司联系人'
            t.string  :clearance_company_email,:comment => '清关公司邮箱' 
            t.string  :clearance_company_telephone, :comment => '清关公司电话'

            t.string  :import_company_name, :comment => '进口公司名称'
            t.string  :import_company_address,:comment => '进口公司地址'
            t.string  :import_company_contacts,:comment => '进口公司联系人'
            t.string  :import_company_email,:comment => '进口公司邮箱' 
            t.string  :import_company_telephone, :comment => '进口公司电话'

            t.string  :buyer_company_name, :comment => '买方公司名称'
            t.string  :buyer_company_address,:comment => '买方公司地址'
            t.string  :buyer_company_contacts,:comment => '买方公司联系人'
            t.string  :buyer_company_email,:comment => '买方公司邮箱' 
            t.string  :buyer_company_telephone, :comment => '买方公司电话'
            t.string  :buyer_elivery_wharf, :comment => '买方交货码头'

            t.string  :seller_company_name, :comment => '卖方公司名称'
            t.string  :seller_company_address,:comment => '卖方公司地址'
            t.string  :seller_company_contacts,:comment => '卖方公司联系人'
            t.string  :seller_company_email,:comment => '卖方公司邮箱' 
            t.string  :seller_company_telephone, :comment => '卖方公司电话'
            t.string  :seller_elivery_wharf, :comment => '卖方交货码头'
            t.string  :seller_copmany_warehouse, :comment => '卖方仓库'

            t.integer :status, :limit => 2, :default => 1, :comment => '订单状态 1-已提交 2-已下单 3-备货完成 4-已发货 5-已到港 6-已完成'

            t.integer :product_price, :comment => '产品总价'
            t.integer :design_price, :comment => '设计服务费'
            t.integer :other_price, :comment => '其他价格'
            t.integer :total_price, :comment => '订单总价'
            t.timestamps
        end
      
    end
end
