# encoding: utf-8
# 订单操作记录表
class CreateOrderRecords  < ActiveRecord::Migration[5.1]
    def change
        create_table(:order_records, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
            t.integer   :order_id,  :comment=>'订单id'
            t.integer   :operate_id,    :comment=>'操作者id'
            t.integer   :operate_rank,  :comment =>'操作者身份'
            t.integer   :operate_type,  :comment =>'操作类型'
            t.timestamps
        end
      
    end
end
