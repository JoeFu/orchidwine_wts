# encoding: utf-8
# 供应商表
class CreateVendors  < ActiveRecord::Migration[5.1]
  def change
    create_table(:vendors, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :vendor_code, :comment=>'供应商编码'
      t.string :name, :comment=>'供应商名称'
      t.string :address, :comment => '地址'
      t.string :telphone, :comment=>'联系电话'
      t.timestamps
    end
    
  end
end
