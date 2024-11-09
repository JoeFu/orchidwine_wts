# encoding: utf-8
# 产品表
class CreateProductions  < ActiveRecord::Migration[5.1]
	def change
		create_table(:productions, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
			t.integer :user_id,:comment=>'用户id'
			t.string  :production_code, :comment=>'产品简码'
			t.string  :production_full_code, :comment=>'产品全码'
			t.string  :origin_code, :comment=>'产品编码'
			t.string  :origin_desc, :comment => '产品描述'
			t.string  :bottle_code, :comment=>'酒瓶编码'
			t.string  :bottle_cover, :comment => '酒瓶缩略图'
			t.string  :bottel_vendor_code,:comment => '酒瓶供应商代码'
			t.integer :bottle_height,:comment => '瓶高'
			t.integer :bottle_volume,:comment => '瓶子容量' 
			t.integer :bottle_weight, :comment => '瓶子重量'
			t.integer :bottle_max_level,:comment => '最大标签高度'
			t.string  :bottle_shape,:comment => '瓶形'
			t.string  :bottle_angle,:comment => '瓶身角度'
			t.integer :bottle_diam, :comment => '瓶身直径'
			t.string  :bottle_neck_size, :comment => '瓶口大小'
			t.integer :tray_bottle,:comment => '每托盘瓶数'
			t.string  :seal_way,:comment => '封瓶方式'
			t.string  :seal_code,:comment => '封瓶物料编码'
			t.string  :stopper_desc,:comment => '酒塞'
			t.string  :stopper_img,:comment => '酒塞图案'
			t.string  :cap_desc,:comment => '酒帽名称'
			t.string  :cap_color,:comment => '酒帽颜色'
			t.string  :cap_img, :comment => '酒帽图片'
			t.string  :wine_label_code,:comment => '酒标编码'
			t.string  :wine_front_img,:comment => '酒标前标'
			t.string  :wine_behind_img,:comment => '酒标后标'
			t.string  :chinese_label,:comment => '中文背标'
			t.string  :bar_code_info,:comment => '条码信息'
			t.string  :divider_code,:comment => '分隔板编码'
			t.string  :divider_desc,:comment => '分隔板描述'
			t.string  :box_code,:comment => '纸箱编码'
			t.string  :box_desc,:comment => '纸箱描述'
			t.string  :stack_code,:comment => '托盘类型编码'
			t.string  :stack_desc,:comment => '托盘描述'
			t.timestamps
		end
	  
	end
end
