# 发货前待处理订单的产品
# 订单到排产状态是就更新到此过渡表内
class OrderProductionTransition < ApplicationRecord
  belongs_to :order_production
  belongs_to :order
  belongs_to :user

  def show_order_number
    num_str = [self.order_number, self.is_split].join('-')
    num_str = self.order_number if self.is_split == 0

    html = <<-HTML
    <a class="btn-link" href="/admin/orders/%s">%s</a>
    HTML
    return html % [self.order_id, num_str]
  end

  def show_in_delivery
    [
      order_production.brand.blank? ? nil : "<small class='text-muted'>[#{order_production.brand}]</small>",
      order_production.is_hb == 1 ? '灌装服务' : order_production.bulk_wine_desc,
      "<b class='text-dark'>#{num.ts}</b>",
      "<small class='text-muted'>#{order_production.package.to_i}pk 111</small>"
    ].join(' ')
      # order_production.produced.zero? ? "<b class='text-danger'>未灌装</b>" : '已灌装'
  end
  
  def self.init
    Order.where(status: 2).preload(:order_productions).map do |order|
      order.order_productions.map do |order_production|
        args = {
          order_id: order_production.order_id,
          order_number: order.order_number,
          user_id: order.user_id,
          order_production_id: order_production.id,
          num: order_production.production_num,
        }

        self.create args
      end
    end
  end
end
