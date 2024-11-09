# encoding: utf-8
# 等待预约集装箱订单表
class CreateWaitAppointmentOrders  < ActiveRecord::Migration[5.1]
  def change
    create_table(:wait_appointment_orders, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.integer :container, :limit => 2, :default => 1,:comment=> '集装箱类型 1 => 40呎柜，2 => 20呎柜'
      t.integer :total_bottle_num,:comment => '总瓶数'
      t.string  :destination,:comment => '发往地'
      t.timestamps
    end
  end
end