# encoding: utf-8
# 订单副表
class CreateOrderProductions  < ActiveRecord::Migration[5.1]
    def change
        create_table(:order_productions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
            t.integer :order_id, :comment => '主订单id'
            t.integer :production_id, :comment => '产品ID'
            t.string  :production_code, :comment => '产品编码'
            t.string  :origin_desc, :comment => '产品'
            t.string  :production_num, :comment => '产品数量'
            t.string  :price, :comment => '产品价格'
            t.string  :batch, :comment => '批次'
            t.string  :container_number, :comment => '集装箱号'
            t.string  :boat_number, :comment => '船号'
            t.string  :port, :comment => '港口'
            t.string  :transport_status, :comment => '运输状态'
            t.timestamps
        end
      
    end
end
