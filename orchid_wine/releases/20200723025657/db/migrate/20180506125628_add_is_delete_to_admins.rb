class AddIsDeleteToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :is_delete, :integer, :limit => 1, :default => 0
  end
end
