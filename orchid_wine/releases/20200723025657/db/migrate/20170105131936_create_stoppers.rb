# encoding: utf-8
# 酒塞表
class CreateStoppers  < ActiveRecord::Migration[5.1]
  def change
    create_table(:stoppers, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :texture_code, :comment=>'材质编码'
      t.string :texture_des, :comment=> '材质描述'
      t.timestamps
    end
    
  end
end
