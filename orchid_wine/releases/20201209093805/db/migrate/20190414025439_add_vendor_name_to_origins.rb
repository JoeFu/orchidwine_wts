class AddVendorNameToOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column :origins, :vendor_name, :string
  end
end
