class AddChineseBackLabelToWineLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :wine_labels, :chinese_back_label, :integer,:limit => 2,:default => 0,:comment => '是否需要中文背标，1：是，0：否'
  end
end