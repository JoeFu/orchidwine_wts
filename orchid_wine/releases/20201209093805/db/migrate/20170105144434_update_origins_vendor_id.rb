class UpdateOriginsVendorId < ActiveRecord::Migration[5.1]
  def change
    rename_column :origins, :Vendor_id, :vendor_id
  end
end