class AddTrueNameToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :true_name, :string, :comment => '管理员名字'
  end
end