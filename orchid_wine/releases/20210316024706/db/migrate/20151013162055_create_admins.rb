# encoding: utf-8
# 管理员表
class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table(:admins, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8') do |t|
      t.string    :user_name,     :null => false, :limit => 16,   :comment => '用户名'
      t.string    :password,      :null => false, :limit => 32,   :comment => '密码'
      t.string    :encrypt,       :null => false, :limit => 16,   :comment => '加密串'
      t.string    :name,                          :limit => 20,   :comment => '姓名'
      t.string    :mobile, 	                      :limit => 11,   :comment => '手机号'
      t.string    :email,                         :limit => 50,   :comment => '邮箱'
      t.integer   :role,                          :default => 0,  :comment => '角色'
      t.integer   :status,        :default => 1,  :limit => 1,    :comment => '状态, 0 - 禁用, 1 - 正常'
      t.timestamps
    end
    
    add_index :admins, :user_name
    add_index :admins, :name
    add_index :admins, :email
  end
end
