class UpdateDividersDividerType < ActiveRecord::Migration[5.1]
  def change
    change_column :dividers, :divider_type, :string
  end
end