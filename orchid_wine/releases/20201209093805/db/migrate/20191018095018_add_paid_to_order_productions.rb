class AddPaidToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :paid, :integer, :default => 0, :limit => 2
  end
end
