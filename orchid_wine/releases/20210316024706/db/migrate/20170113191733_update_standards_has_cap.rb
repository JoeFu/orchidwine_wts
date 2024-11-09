class UpdateStandardsHasCap < ActiveRecord::Migration[5.1]
  def change
    change_column :standards, :has_cap, :integer, :limit => 2, :default => 1
  end
end