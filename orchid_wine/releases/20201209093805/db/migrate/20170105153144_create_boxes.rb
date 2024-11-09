# encoding: utf-8
# 纸箱表
class CreateBoxes  < ActiveRecord::Migration[5.1]
  def change
    create_table(:boxes, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :box_code, :comment=> '纸箱编码'
      t.integer :box_type, :limit => 2, :comment=>'纸箱类型'
      t.timestamps
    end
  end
end
