class MoveProductionToOrderProduction < ActiveRecord::Migration[5.1]
  def change

    drop_table :processed_orders
    drop_table :processed_order_productions
    drop_table :cursor_order_productions

    add_column :order_productions, :origin_code, :string
    # add_column :order_productions, :seal_way, :string
    # add_column :order_productions, :seal_code, :string
    # add_column :order_productions, :stopper_img, :string
    add_column :order_productions, :bottle_id, :integer
    add_column :order_productions, :bottle_code, :string
    add_column :order_productions, :stopper_id, :integer
    add_column :order_productions, :stopper_desc, :string
    add_column :order_productions, :cap_id, :integer
    add_column :order_productions, :cap_desc, :string
    add_column :order_productions, :cap_color, :string
    add_column :order_productions, :divider_id, :integer
    add_column :order_productions, :divider_desc, :string
    add_column :order_productions, :box_id, :integer
    add_column :order_productions, :box_desc, :string
    # add_column :order_productions, :cap_img, :string
    # add_column :order_productions, :wine_label_code, :string
    # add_column :order_productions, :wine_front_img, :string
    # add_column :order_productions, :wine_behind_img, :string
    # add_column :order_productions, :bar_code_info, :string
    # add_column :order_productions, :stack_code, :string
    # add_column :order_productions, :stack_desc, :string
    # add_column :order_productions, :cap_texture_des, :string
    # add_column :order_productions, :has_cap, :integer, :limit => 2, :default => 1
    # add_column :order_productions, :wine_label_id, :integer
    add_column :order_productions, :label_name, :string
    add_column :order_productions, :brand, :string
    add_column :order_productions, :package, :string
    add_column :order_productions, :chinese_label, :string
    # add_column :order_productions, :material, :string
    # add_column :order_productions, :cap_color_id, :integer
    add_column :order_productions, :remark, :text

    add_column :pending_order_productions, :origin_id, :integer
    add_column :pending_order_productions, :origin_code, :string
    add_column :pending_order_productions, :origin_desc, :string
    add_column :pending_order_productions, :bottle_id, :integer
    add_column :pending_order_productions, :bottle_code, :string
    # add_column :pending_order_productions, :seal_way, :string
    # add_column :pending_order_productions, :seal_code, :string
    add_column :pending_order_productions, :stopper_desc, :string
    # add_column :pending_order_productions, :stopper_img, :string
    add_column :pending_order_productions, :cap_desc, :string
    add_column :pending_order_productions, :cap_color, :string
    # add_column :pending_order_productions, :cap_img, :string
    # add_column :pending_order_productions, :wine_label_code, :string
    # add_column :pending_order_productions, :wine_front_img, :string
    # add_column :pending_order_productions, :wine_behind_img, :string
    add_column :pending_order_productions, :chinese_label, :string
    # add_column :pending_order_productions, :bar_code_info, :string
    add_column :pending_order_productions, :divider_id, :integer
    add_column :pending_order_productions, :divider_desc, :string
    add_column :pending_order_productions, :box_id, :integer
    add_column :pending_order_productions, :box_desc, :string
    # add_column :pending_order_productions, :stack_code, :string
    # add_column :pending_order_productions, :stack_desc, :string
    # add_column :pending_order_productions, :cap_texture_des, :string
    # add_column :pending_order_productions, :has_cap, :integer, :limit => 2, :default => 1
    # add_column :pending_order_productions, :wine_label_id, :integer
    add_column :pending_order_productions, :label_name, :string
    add_column :pending_order_productions, :brand, :string
    add_column :pending_order_productions, :package, :string
    # add_column :pending_order_productions, :material, :string
    add_column :pending_order_productions, :cap_id, :integer
    add_column :pending_order_productions, :stopper_id, :integer
    # add_column :pending_order_productions, :cap_color_id, :integer
    add_column :pending_order_productions, :remark, :text

    add_column :delivery_order_productions, :origin_id, :integer
    add_column :delivery_order_productions, :origin_code, :string
    add_column :delivery_order_productions, :origin_desc, :string
    add_column :delivery_order_productions, :bottle_id, :integer
    add_column :delivery_order_productions, :bottle_code, :string
    # add_column :delivery_order_productions, :seal_way, :string
    # add_column :delivery_order_productions, :seal_code, :string
    add_column :delivery_order_productions, :stopper_desc, :string
    # add_column :delivery_order_productions, :stopper_img, :string
    add_column :delivery_order_productions, :cap_desc, :string
    add_column :delivery_order_productions, :cap_color, :string
    # add_column :delivery_order_productions, :cap_img, :string
    # add_column :delivery_order_productions, :wine_label_code, :string
    # add_column :delivery_order_productions, :wine_front_img, :string
    # add_column :delivery_order_productions, :wine_behind_img, :string
    add_column :delivery_order_productions, :chinese_label, :string
    # add_column :delivery_order_productions, :bar_code_info, :string
    add_column :delivery_order_productions, :divider_id, :integer
    add_column :delivery_order_productions, :divider_desc, :string
    add_column :delivery_order_productions, :box_id, :integer
    add_column :delivery_order_productions, :box_desc, :string
    # add_column :delivery_order_productions, :stack_code, :string
    # add_column :delivery_order_productions, :stack_desc, :string
    # add_column :delivery_order_productions, :cap_texture_des, :string
    # add_column :delivery_order_productions, :has_cap, :integer, :limit => 2, :default => 1
    # add_column :delivery_order_productions, :wine_label_id, :integer
    add_column :delivery_order_productions, :label_name, :string
    add_column :delivery_order_productions, :brand, :string
    add_column :delivery_order_productions, :package, :string
    # add_column :delivery_order_productions, :material, :string
    add_column :delivery_order_productions, :cap_id, :integer
    add_column :delivery_order_productions, :stopper_id, :integer
    # add_column :delivery_order_productions, :cap_color_id, :integer
    add_column :delivery_order_productions, :remark, :text
  end
end
