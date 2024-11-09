# encoding: utf-8
# 待拆箱或拼箱预处理订单表
class CreatePretreatmentOrders  < ActiveRecord::Migration[5.1]
  def change
    create_table(:pretreatment_orders, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.integer :user_id, :comment=> '用户id'
      t.integer :order_id, :comment => '订单id'
      t.string  :order_number,:comment => '订单编号'
      t.integer :total_bottle_num,:comment => '总瓶数'
      t.string  :destination,:comment => '发往地'
      t.timestamps
    end
  end
end
