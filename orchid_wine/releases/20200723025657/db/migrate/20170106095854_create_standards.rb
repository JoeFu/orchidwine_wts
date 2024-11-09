
# encoding: utf-8
# 标准品表
class CreateStandards  < ActiveRecord::Migration[5.1]
  def change
    create_table(:standards, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :standard_code, :comment => '标准品编码'
      t.string :des, :comment => '标准品描述'
      t.string :bin_way, :comment => '装箱方式'
      t.string :stack_way, :comment => '堆码方式'
      t.integer :origin_id, :comment => '产品ID'
      t.integer :bottle_id, :comment => '酒瓶ID'
      t.integer :stopper_id, :comment => '酒塞ID'
      t.integer :stopper_image_id,  :comment => '酒塞图案ID'
      t.integer :has_cap,   :limit => 2, :comment => '有无酒帽 1-无 2-有'
      t.integer :cap_id,    :comment => '酒帽ID'
      t.integer :cap_image_id,  :comment => '酒帽图案ID'
      t.integer :cap_color_id,  :comment => '酒帽颜色ID'
      t.integer :divider_id, :comment => '分隔板ID'
      t.integer :box_id,    :comment => '纸箱ID'
      t.integer :stack_id,  :comment => '托盘ID'
      t.timestamps
    end
  end
end
