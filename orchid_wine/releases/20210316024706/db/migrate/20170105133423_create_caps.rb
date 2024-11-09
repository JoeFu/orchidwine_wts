# encoding: utf-8
# 酒帽表
class CreateCaps  < ActiveRecord::Migration[5.1]
  def change
    create_table(:caps, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :type_code, :comment=>'类型编码'
      t.string :type_des, :comment=> '类型描述'
      t.string :texture_code, :comment=>'材质编码'
      t.string :texture_des, :comment=> '材质描述'
      t.timestamps
    end
  end
end
