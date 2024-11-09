class AddRemarkToOp < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :remark, :text
  end
end
