class AddPackageToUnbottleds < ActiveRecord::Migration[5.1][5.1]
  def change
    add_column :unbottleds, :package, :string
    add_column :unbottleds, :custom_number, :integer, :default => 0
  end
end
