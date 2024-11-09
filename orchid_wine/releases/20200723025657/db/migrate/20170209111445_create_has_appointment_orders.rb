# encoding: utf-8
# 已预约集装箱订单表
class CreateHasAppointmentOrders  < ActiveRecord::Migration[5.1]
  def change
    create_table(:has_appointment_orders, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
    	t.string  :booking_number,:comment => '船公司预约号'
    	t.string  :wea_number, :comment => 'WEA出口许可证号'
    	t.string  :container_number,:comment => '集装箱号'
      t.integer :container, :limit => 2, :default => 1,:comment => '集装箱类型 1 => 40呎柜，2 => 20呎柜'
      t.integer :total_bottle_num,:comment => '总瓶数'
      t.string  :destination,:comment => '发往地'
      t.integer :status,:limit => 2,:default => 1,:comment =>  '1:已预约，2:已启运，3:已到港,4:已完成'
      t.timestamps
    end
  end
end