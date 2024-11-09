class AddAdminIdToImportCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :import_companies, :admin_id, :integer
  end
end
