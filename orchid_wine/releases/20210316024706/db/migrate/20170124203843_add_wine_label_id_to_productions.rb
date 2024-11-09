class AddWineLabelIdToProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :wine_label_id, :integer, :comment => '酒标id'
    add_column :productions, :label_name,:string,:comment => '酒标名字'
  end
end