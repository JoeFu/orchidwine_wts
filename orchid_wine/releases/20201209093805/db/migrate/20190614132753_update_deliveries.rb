class UpdateDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_column :deliveries, :cutoff_date, :datetime
    add_column :deliveries, :plan_date, :date
    add_column :deliveries, :get_container_date, :date
  end
end
