class AddSizeToContainers < ActiveRecord::Migration[5.1]
  def change
    add_column :containers, :size, :integer, :limit => 2, :default => 20
  end
end
