class AddImportCompanyUscc < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :import_company_uscc, :string
    add_column :deliveries, :ocean_insurance, :integer, :limit => 2, :default => 0
  end
end
