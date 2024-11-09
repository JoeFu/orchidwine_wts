class RemoveBottleType < ActiveRecord::Migration[5.1]
  def change
    remove_column :bottles, :bottle_type
  end
end
