# encoding: utf-8
# 酒标表
class CreateWineLabels  < ActiveRecord::Migration[5.1]
  def change
    create_table(:wine_labels, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :label_code, :comment => '自动编号'
      t.string :front_label, :comment => '前标'
      t.string :behind_label, :comment => '后标'
      t.integer :operate_id, :comment => '创建者ID'
      t.integer :operate_rank, :limit => 2, :comment => '创建者身份 1-管理员 2-客户'
      t.timestamps
    end
  end
end
