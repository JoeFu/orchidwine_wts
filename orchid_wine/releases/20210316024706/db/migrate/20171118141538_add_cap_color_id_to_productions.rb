class AddCapColorIdToProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :cap_color_id, :integer
  end
end
