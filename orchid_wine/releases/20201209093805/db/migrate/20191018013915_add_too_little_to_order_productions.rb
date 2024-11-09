class AddTooLittleToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :too_little, :integer, :default => 0, :limit => 2
  end
end
