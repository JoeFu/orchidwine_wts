class AddIndexToWebProductCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :web_product_categories, :sort, :integer, :default => 1, :comment => '排序'
    add_index :web_product_categories, :sort
  end
end
