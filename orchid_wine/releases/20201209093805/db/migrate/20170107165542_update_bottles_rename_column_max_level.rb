class UpdateBottlesRenameColumnMaxLevel < ActiveRecord::Migration[5.1]
  def change
    rename_column :bottles, :max_Level, :max_level
  end
end