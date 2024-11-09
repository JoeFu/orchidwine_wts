class AddLabelNameToWineLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :wine_labels, :label_name, :string, :comment => '酒标名称'
  end
end