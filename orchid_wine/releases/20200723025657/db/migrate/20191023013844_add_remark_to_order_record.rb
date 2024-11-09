class AddRemarkToOrderRecord < ActiveRecord::Migration[5.1]
  def change
    add_column :order_records, :remark, :string
  end
end
