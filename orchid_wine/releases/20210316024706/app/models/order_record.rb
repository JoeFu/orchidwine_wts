# encoding: utf-8
class OrderRecord < ApplicationRecord
  belongs_to :order

  OPERATE_TYPE = {
    1 => '提交订单',
    2 => '撤销订单',
    3 => '回复订单',
    4 => '确认下单',
    5 => '灌装操作',
    6 => '恢复订单',
    7 => '复核完成',
    8 => '订单续存',
    9 => '超期回退到购物车',
    10 => '支付尾款',
  }

  OPERATE_RANK = {
    1 => '管理员',
    2 => '客户',
  }
end
