class AddCapTextureDesToProductions < ActiveRecord::Migration[5.1]
  def change
    add_column :productions, :cap_texture_des, :string, :comment => '酒帽材质'
    add_column :productions, :has_cap, :integer, :limit => 2, :default => 1, :comment => '有无酒帽 1-无 2-有'
  end
end