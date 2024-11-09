class AddUserIdToWineLabels < ActiveRecord::Migration[5.1]
  def change
    add_column :wine_labels, :user_id, :integer
    add_column :wine_labels, :admin_id, :integer
  end
end
