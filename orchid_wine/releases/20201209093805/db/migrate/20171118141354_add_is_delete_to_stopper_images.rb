class AddIsDeleteToStopperImages < ActiveRecord::Migration[5.1]
  def change
    add_column :stopper_images, :is_delete, :integer, :limit => 2, :default => 1, :comment => '是否删除 1-否 2-是'
  end
end