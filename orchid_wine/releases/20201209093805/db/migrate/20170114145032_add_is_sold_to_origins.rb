class AddIsSoldToOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column :origins, :is_sold, :integer, :limit => 2, :default => 2, :comment => '是否上架 1-否 2-是'
  end
end