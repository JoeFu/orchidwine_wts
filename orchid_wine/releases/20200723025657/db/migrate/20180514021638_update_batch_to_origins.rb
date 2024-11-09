class UpdateBatchToOrigins < ActiveRecord::Migration[5.1]
  def change
    change_column :origins, :batch, :string, :limit => 1, :default => 1
  end
end
