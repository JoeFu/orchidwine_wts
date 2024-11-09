class AddInfoToUnbottleds < ActiveRecord::Migration[5.1]
  def change
    add_column :unbottleds, :bottle_code, :string, :limit => 20
    add_column :unbottleds, :divider_code, :string, :limit => 20
    add_column :unbottleds, :box_code, :string, :limit => 20
    
    add_column :unbottleds, :cap_img, :integer, :limit => 2, :default => 0
    add_column :unbottleds, :stopper_img, :integer, :limit => 2, :default => 0
  end
end
