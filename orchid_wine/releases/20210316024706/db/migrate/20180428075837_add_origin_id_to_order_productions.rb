class AddOriginIdToOrderProductions < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :order_productions, :origin_id, :integer, :default => 0
  end
end
