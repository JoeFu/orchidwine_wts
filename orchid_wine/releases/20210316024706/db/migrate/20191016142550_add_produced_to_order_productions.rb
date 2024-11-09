class AddProducedToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :produced, :integer, :default => 0, :comment => '生产状态'
  end
end
