# encoding: utf-8
# 临时订单产品表
class CreateCursorOrderProductions  < ActiveRecord::Migration[5.1]
	def change
		create_table(:cursor_order_productions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
			t.integer :user_id,:comment=>'用户id'
			t.integer  :production_id, :comment=>'产品id'
			t.string  :production_code, :comment=>'产品简码'
			t.string  :origin_desc, :comment => '产品描述'
			t.string  :production_num,:comment => '产品数量'
			t.timestamps
		end
	  
	end
end
