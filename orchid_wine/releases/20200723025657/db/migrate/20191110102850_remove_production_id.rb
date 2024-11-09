class RemoveProductionId < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_productions, :production_id
    remove_column :order_productions, :production_code
  end
end
