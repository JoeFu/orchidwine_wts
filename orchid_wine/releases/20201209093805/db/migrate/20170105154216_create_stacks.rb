# encoding: utf-8
# 托盘表
class CreateStacks  < ActiveRecord::Migration[5.1]
  def change
    create_table(:stacks, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :stack_code, :comment=> '托盘编码'
      t.integer :stack_type, :limit => 2, :comment=>'托盘类型'
      t.timestamps
    end
  end
end
