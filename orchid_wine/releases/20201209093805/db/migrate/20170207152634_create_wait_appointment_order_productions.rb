# encoding: utf-8
# 等待预约集装箱订单产品表
class CreateWaitAppointmentOrderProductions  < ActiveRecord::Migration[5.1]
  def change
    create_table(:wait_appointment_order_productions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.integer :wait_appointment_order_id, :comment=> '待预约集装箱订单id'
      t.integer :user_id,:comment => '用户id'
      t.integer :order_id,:comment => '订单id'
      t.string :order_number,:comment => '订单号'
      t.integer :production_id,:comment => '产品id'
      t.string  :production_code,:comment => '产品简码'
      t.integer :production_num, :comment => '产品数量' 
      t.timestamps
    end
  end
end