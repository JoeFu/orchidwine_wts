# encoding: utf-8
# 待拆箱或拼箱预处理订单产品属性表
class CreatePretreatmentOrderProductions  < ActiveRecord::Migration[5.1]
  def change
    create_table(:pretreatment_order_productions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.integer :pretreatment_order_id, :comment=> '预处理订单id'
      t.integer :production_id, :comment => '产品id'
      t.string  :production_code, :comment => '产品简码'
      t.integer :production_num, :comment => '产品数量'
      t.timestamps
    end
  end
end