# 集装箱
class Container < ApplicationRecord
  belongs_to :delivery
  has_many :order_production_deliveries, :class_name => "OrderProductionDelivery"


  SIZE = {
    20 => '20尺',
    40 => '40尺',
  }
end