class AddOrderIdToPretreatmentOrderProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :pretreatment_order_productions, :order_id, :integer, :comment => '订单ID'
    add_column :pretreatment_order_productions, :user_id,  :integer, :comment => '用户ID'
    add_column :pretreatment_order_productions, :order_number, :string, :comment => '订单编号'
  end
end