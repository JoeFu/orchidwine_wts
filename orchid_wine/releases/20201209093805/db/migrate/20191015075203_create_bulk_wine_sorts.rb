class CreateBulkWineSorts < ActiveRecord::Migration[5.1]
  def change
    create_table(:bulk_wine_sorts, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.string :code, :null => false
      t.string :name_en, :null => false
      t.string :name_zh, :null => false

      t.integer :is_delete, :limit => 1, :default => 0
   
      t.timestamps
    end
  end
end
