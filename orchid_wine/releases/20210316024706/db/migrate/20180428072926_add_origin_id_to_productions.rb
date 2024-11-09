class AddOriginIdToProductions < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :productions, :origin_id, :integer, :default => 0
  end
end
