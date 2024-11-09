# encoding: utf-8
# 产品表
class CreateOrigins  < ActiveRecord::Migration[5.1]
  def change
    create_table(:origins, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :origin_code, :comment=>'产品编码'
      t.integer :Vendor_id, :comment=>'供应商ID'
      t.string :year, :comment => '年份'
      t.integer :area_id_one, :limit => 2, :comment=>'产地1ID'
      t.integer :area_id_two, :limit => 2, :comment=>'产地2ID'
      t.integer :variety_id_one, :limit => 2, :comment=>'品种1ID'
      t.integer :variety_id_two, :limit => 2, :comment=>'品种2ID'
      t.integer :variety_id_three, :limit => 2, :comment=>'品种3ID'
      t.integer :alcoholic_strength, :comment => '酒精度'
      t.string  :lip, :comment => 'LIP文件'
      t.integer :is_soldout, :default => 1, :limit => 2, :comment => '是否下架 1-否 2-是'
      t.string  :analysis, :comment => '分析报告'
      t.timestamps
    end
    
  end
end
