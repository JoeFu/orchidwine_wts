class UpdateStacksStackType < ActiveRecord::Migration[5.1]
  def change
    change_column :stacks, :stack_type, :string
  end
end