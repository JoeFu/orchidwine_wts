class AddStatusToBottles < ActiveRecord::Migration[5.1]
  def change
  	add_column :bottles, :status, :integer, :limit => 2, :default => 1
  end
end
