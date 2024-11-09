class AddAdminIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_id, :integer
    add_index :users, :admin_id
  end
end
