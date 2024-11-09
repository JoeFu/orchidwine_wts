# encoding: utf-8
# 酒帽图案表
class CreateCapImages  < ActiveRecord::Migration[5.1]
  def change
    create_table(:cap_images, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :image_code, :comment => '自动编号'
      t.string :cover, :comment => '图案'
      t.integer :operate_id, :comment => '创建者ID'
      t.integer :operate_rank, :limit => 2, :comment => '创建者身份 1-管理员 2-客户'
      t.timestamps
    end
  end
end
