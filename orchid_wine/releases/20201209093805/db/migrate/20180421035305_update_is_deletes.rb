class UpdateIsDeletes < ActiveRecord::Migration[5.1][5.1]
  def change
    [
      :caps,
      :cap_images,
      :cap_colors,
      :dividers,
      :boxes,
      :bottles,
      :origins,
      :productions,
      :stacks,
      :standards,
      :stopper_images,
      :stoppers,
      :vendors,
      :wine_labels,
    ].map do |key|
      remove_column key, :is_delete
      add_column key, :is_delete, :integer, :limit => 1, :default => 0
    end
  end
end
