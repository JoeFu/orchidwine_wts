class UpdateOriginsSold < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :origins, :status, :integer, :limit => 1, :default => 0
    remove_column :origins, :is_sold
  end
end
