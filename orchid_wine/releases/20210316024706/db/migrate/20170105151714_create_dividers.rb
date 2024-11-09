# encoding: utf-8
# 分隔板表
class CreateDividers  < ActiveRecord::Migration[5.1]
  def change
    create_table(:dividers, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :divider_code, :comment=> '分隔板编码'
      t.integer :divider_type, :limit => 2, :comment=>'分隔板类型'
      t.timestamps
    end
  end
end
