class AddProductionIdToWineLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :wine_labels, :production_id, :integer
    add_index :wine_labels, :production_id
  end
end
