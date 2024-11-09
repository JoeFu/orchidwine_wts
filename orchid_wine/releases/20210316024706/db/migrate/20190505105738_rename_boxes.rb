class RenameBoxes < ActiveRecord::Migration[5.1]
  def change
    rename_table :boxes, :cartons

    remove_column :cartons, :box_code
    remove_column :cartons, :box_name

    rename_column :cartons, :box_type, :desc
    
    rename_column :productions, :box_code, :carton_id
    rename_column :productions, :box_desc, :carton_desc
    
    rename_column :order_productions, :box_id, :carton_id
    rename_column :order_productions, :box_desc, :carton_desc

    rename_column :pending_order_productions, :box_id, :carton_id
    rename_column :pending_order_productions, :box_desc, :carton_desc

    rename_column :delivery_order_productions, :box_id, :carton_id
    rename_column :delivery_order_productions, :box_desc, :carton_desc

    rename_column :unbottleds, :box_id, :carton_id
    remove_column :unbottleds, :box_code
  end
end
