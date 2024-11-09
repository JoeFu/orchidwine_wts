class UpdateBottlesBottleType < ActiveRecord::Migration[5.1]
  def change
    change_column :bottles, :bottle_type, :string
  end
end