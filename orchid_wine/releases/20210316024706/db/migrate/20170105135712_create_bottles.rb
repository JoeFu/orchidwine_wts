# encoding: utf-8
# 酒瓶表
class CreateBottles  < ActiveRecord::Migration[5.1]
  def change
    create_table(:bottles, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :cover, :comment=>'缩略图'
      t.integer :bottle_type, :comment => '瓶型'
      t.string :bottle_code, :comment=> '内部代码'
      t.string :vendor_code, :comment=>'供应商代码'
      t.integer :seal, :comment => '封瓶方式 1-木塞 2-螺旋盖'
      t.integer :height, :comment => '瓶高'
      t.integer :volume, :comment => '容量'
      t.integer :weight, :comment => '重量'
      t.integer :max_Level, :comment => '最大标高'
      t.string  :shape, :comment => '瓶形状'
      t.string  :angle, :comment => '瓶身角度'
      t.integer :diam,  :comment => '瓶身直径'
      t.string  :neck_size, :comment => '瓶口大小'
      t.integer  :tray_bottle, :comment => '瓶数每托盘'
      t.timestamps
    end
  end
end
