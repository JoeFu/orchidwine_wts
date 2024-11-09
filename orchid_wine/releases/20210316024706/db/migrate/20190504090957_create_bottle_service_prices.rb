class CreateBottleServicePrices < ActiveRecord::Migration[5.1]
  def change
    create_table(:bottle_service_prices, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

			t.string :bottle_type
			t.integer :packing_type, :default => 0
			t.integer :set_up_fee, :default => 0

			t.float :price_1, :default => 0
			t.float :price_2, :default => 0
			t.float :price_3, :default => 0
			t.float :price_4, :default => 0
			t.float :price_5, :default => 0

      t.timestamps
    end
  end
end
