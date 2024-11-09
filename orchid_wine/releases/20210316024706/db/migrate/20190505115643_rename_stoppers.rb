class RenameStoppers < ActiveRecord::Migration[5.1]
  def change
    rename_table :stoppers, :corks

    rename_column :productions, :stopper_id, :cork_id
    rename_column :productions, :stopper_desc, :cork_desc

    rename_column :order_productions, :stopper_id, :cork_id
    rename_column :order_productions, :stopper_desc, :cork_desc

    rename_column :pending_order_productions, :stopper_id, :cork_id
    rename_column :pending_order_productions, :stopper_desc, :cork_desc

    rename_column :delivery_order_productions, :stopper_id, :cork_id
    rename_column :delivery_order_productions, :stopper_desc, :cork_desc
    
    rename_column :unbottleds, :stopper_id, :cork_id
  end
end
