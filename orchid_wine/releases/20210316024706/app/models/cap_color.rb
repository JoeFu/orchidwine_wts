# encoding: utf-8
class CapColor < ApplicationRecord

  def self.select_options
    self.where(:is_delete => 0).pluck(:color_value)
  end

  # OPTIONS = [
  #   "空值", "Silver", "红色带金边", "Black_Gold", "Red", "Black", "Gold", "Customer_P", "White", "Blue", "Creamy"
  # ]

end