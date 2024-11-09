# encoding: utf-8
class CreateWebProductCategories  < ActiveRecord::Migration[5.1]
  def change
    create_table(:web_product_categories, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
    	t.string :name
    	t.string :en_name
      t.timestamps
    end
  end
end