class AddNumbersToUnbottleds < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :unbottleds, :stock, :integer, :default => 0
    add_column :unbottleds, :min_number, :integer, :default => 0
    add_column :unbottleds, :sold_count, :integer, :default => 0
    add_column :unbottleds, :selling_count, :integer, :default => 0
  end
end
