class AddDatesToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :date_create, :datetime, :comment => '下单日期'
    add_column :orders, :date_review, :datetime, :comment => '管理员复核日期'
    add_column :orders, :date_recheck, :datetime, :comment => '财务复核日期'
  end
end
