class CreateUnbottledStockLogs < ActiveRecord::Migration[5.1][5.1]
  def change
    create_table(:unbottled_stock_logs, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      
      t.integer :origin_id
      t.integer :unbottled_id
      t.integer :stock
      t.integer :admin_id

      t.timestamps
    end
  end
end
