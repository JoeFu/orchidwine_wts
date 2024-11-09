class AddCurrencyToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :currency, :integer, :limit => 2, :default => 1, :comment => '币种 1-澳元 2-人民币'
  end
end