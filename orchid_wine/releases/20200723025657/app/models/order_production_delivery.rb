# Delivery 与 OrderProduction 关系表
class OrderProductionDelivery < ApplicationRecord
  belongs_to :delivery
  belongs_to :order_production
  belongs_to :order
  belongs_to :user
  belongs_to :container


  def show_container
    return nil if container.blank?
    return container.container_number if container.container_number.present?
    ['NO', container.id].join('-')
  end

  def show_order_number
    num_str = [self.order_number, self.is_split].join('-')
    num_str = self.order_number if self.is_split == 0

    html = <<-HTML
    <a class="btn-link" href="/admin/orders/%s">%s</a>
    HTML
    return html % [self.order_id, num_str]
  end

  def show_in_delivery
    strs = [
      order_production.brand.blank? ? nil : "<b class='text-dark'>[#{order_production.brand}]</b>",
      order_production.is_hb == 1 ? '灌装服务' : order_production.bulk_wine_desc,
      "<smal>#{num.ts}</smal>",
      "<smal class='text-muted'>#{order_production.package.to_i}pk</small>",
      "<b class='text-dark'>#{num/order_production.package.to_i}箱</small>",
    ]

    # if delivery.status == 1
    #   strs << order_production.produced.zero? ? "<b class='text-danger'>未灌装</b>" : '已灌装'
    # end
    strs.join(' ')
  end
end
