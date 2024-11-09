class AddBatchToOrigins < ActiveRecord::Migration[5.1]
  def change
    add_column :origins, :batch, :integer, :limit => 2, :default => 1
  end
end
