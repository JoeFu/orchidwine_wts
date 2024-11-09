class AddSealCodeToStandards < ActiveRecord::Migration[5.1]
  def change
    add_column :standards, :seal_code, :string, :comment => '封瓶物料编码'
  end
end