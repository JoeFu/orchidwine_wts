class AddProduceTypeToOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :order_productions, :produce_type, :string, :comment => '生产类型'
  end
end    
