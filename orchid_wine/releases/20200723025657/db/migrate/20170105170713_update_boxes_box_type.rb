class UpdateBoxesBoxType < ActiveRecord::Migration[5.1]
  def change
    change_column :boxes, :box_type, :string
  end
end