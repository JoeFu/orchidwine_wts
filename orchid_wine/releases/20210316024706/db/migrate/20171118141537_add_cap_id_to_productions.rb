class AddCapIdToProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :cap_id, :integer
    add_column :productions, :stopper_id, :integer
  end
end

