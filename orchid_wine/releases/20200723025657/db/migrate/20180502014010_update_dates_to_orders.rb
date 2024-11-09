class UpdateDatesToOrders < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :date_create, :date_confirm
    rename_column :orders, :date_recheck, :date_finance_check
    rename_column :orders, :date_review, :date_recheck
  end
end
