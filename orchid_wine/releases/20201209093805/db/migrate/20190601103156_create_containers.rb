class CreateContainers < ActiveRecord::Migration[5.1]
  def change
    create_table(:containers, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
      t.integer :delivery_id
      t.string :container_number

      t.timestamps
    end
    add_index :containers, :delivery_id
  end
end
