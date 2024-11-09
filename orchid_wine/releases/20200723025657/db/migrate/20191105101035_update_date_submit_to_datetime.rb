class UpdateDateSubmitToDatetime < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :date_submit, :datetime
  end
end
