class UpdateStockPackaging < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_wine_stocks, :cap_color, :string
    
    # remove_column :bulk_wine_stocks, :cap_color_id
    remove_column :bulk_wine_stocks, :cap_image_id
    remove_column :bulk_wine_stocks, :stack_id
    remove_column :bulk_wine_stocks, :bottle_code
    remove_column :bulk_wine_stocks, :divider_code
    remove_column :bulk_wine_stocks, :cap_img
    remove_column :bulk_wine_stocks, :stopper_img

  end
end
