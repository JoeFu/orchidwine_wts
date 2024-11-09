class AddDateSubmitToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :date_submit, :date
  end
end
