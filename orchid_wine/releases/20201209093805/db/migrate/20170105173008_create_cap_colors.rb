# encoding: utf-8
# 酒帽颜色表
class CreateCapColors  < ActiveRecord::Migration[5.1]
  def change
    create_table(:cap_colors, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :color_code, :comment => '自动编号'
      t.string :color_value, :comment => '酒帽标准色值'
      t.integer :operate_id, :comment => '创建者ID'
      t.integer :operate_rank, :limit => 2, :comment => '创建者身份 1-管理员 2-客户'
      t.timestamps
    end
  end
end
