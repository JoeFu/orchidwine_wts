class AddSendMailToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :send_mail, :integer, :limit => 2, :default => 0
  end
end
