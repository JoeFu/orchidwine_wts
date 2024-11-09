class UpadteNumbersDefaultToProductions < ActiveRecord::Migration[5.1]
  def change
    # change_column :productions, :bottle_volume, :integer, :null => false, :default => 0
    change_column :orders, :status, :integer, :null => false, :default => 1, :limit => 2
  end
end
