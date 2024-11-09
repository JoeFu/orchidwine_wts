class AddTrademarkToHasAppointmentOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :has_appointment_orders, :trademark, :string, :comment => '商标'
    add_column :has_appointment_orders, :hygienic_license, :string, :comment => '自由销售及卫生许可证'
    add_column :has_appointment_orders, :packing_list, :string, :comment => '产品装箱单'
    add_column :has_appointment_orders, :sea_transportation_list, :string, :comment => '海运提单'
    add_column :has_appointment_orders, :customs_clearance, :string, :comment => '中国海关清关报关文件'
  end
end