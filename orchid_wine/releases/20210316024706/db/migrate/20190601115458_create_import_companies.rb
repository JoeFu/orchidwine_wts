class CreateImportCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table(:import_companies, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.string :name
      t.string :contacts
      t.string :telephone
      t.string :email
      t.string :address
      t.string :uscc

      t.timestamps
    end
  end
end
