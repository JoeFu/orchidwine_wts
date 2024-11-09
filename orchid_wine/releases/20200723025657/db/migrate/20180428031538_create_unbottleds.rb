class CreateUnbottleds < ActiveRecord::Migration[5.1][5.1]
  def change
    create_table(:unbottleds, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|

      t.integer :origin_id
      t.integer :bottle_id
      t.integer :stopper_id
      t.integer :cap_id
      t.integer :cap_color_id
      t.integer :cap_image_id
      t.integer :divider_id
      t.integer :box_id
      t.integer :stack_id

      t.timestamps
    end
  end
end
