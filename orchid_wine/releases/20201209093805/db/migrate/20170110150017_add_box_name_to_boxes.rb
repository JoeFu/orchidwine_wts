class AddBoxNameToBoxes < ActiveRecord::Migration[5.1]
  def change
    add_column :boxes, :box_name, :string, :comment => '纸箱名称'
    add_column :boxes, :bottle_number, :integer, :comment => '支数'
  end
end