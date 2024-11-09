class CreateBulkWineYears < ActiveRecord::Migration[5.1]
  def change
    create_table(:bulk_wine_years, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.string :year, :limit => 4, :null => false
      t.integer :is_delete, :limit => 1, :default => 0
      t.timestamps
    end
  end
end
