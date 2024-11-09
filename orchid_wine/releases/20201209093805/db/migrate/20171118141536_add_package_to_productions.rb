class AddPackageToProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :brand, :string
    add_column :productions, :package, :string
    add_column :productions, :material, :string
    add_column :order_productions, :fee_name, :string
    add_column :order_productions, :fee, :string
  end
end
