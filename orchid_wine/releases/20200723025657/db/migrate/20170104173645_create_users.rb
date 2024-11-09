# encoding: utf-8
# 用户表
class CreateUsers  < ActiveRecord::Migration[5.1]
  def change
    create_table(:users, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.string :telphone, :comment=>'电话'
      t.string :name, :comment=>'真实姓名'
      t.string :encrypt, :comment => '登录验证字符串'
      t.string :user_name, :comment=>'登录用户名'
      t.string :password, :comment=>'用户密码'
      t.string :email,:comment=>'电子邮件'
      t.string :company,:comment => '公司名称'
      t.string :company_code,:comment => '公司简码'
      t.integer  :sex,:limit=>2,:default => 0,:comment=>'性别'
      t.integer :role, :limit => 2, :default => 1, :comment => '1=>普通客户，2=>中级客户，3=>高级客户 '
      t.timestamps
    end
    
  end
end
