# 产品基本配置
class BulkWineStock < ApplicationRecord

  belongs_to :bulk_wine
  belongs_to :bottle
  belongs_to :cork
  belongs_to :cap
  belongs_to :divider
  belongs_to :carton

  # integer bulk_wine_id
  # integer bottle_id 瓶型
  # integer cork_id 酒塞
  # integer cap_id 酒帽
  # integer cap_color_id 酒帽颜色
  # integer divider_id 分隔板
  # integer carton_id 纸箱

  # integer package

  # integer :total_stock 总库存
  # integer :stock 可销售库存
  # integer :min_number
  # integer :custom_number
  # integer :sold_count
  # integer :selling_count

  def info
    h = attrs.slice(:min_number,
                    :custom_number,
                    :bottle_id,
                    :cork_id,
                    :cap_id,
                    :cap_color,
                    :cork_print,
                    :cap_print,
                    :carton_id,
                    :divider_id,
                    :package,
                    :bottle_customize,
                    :stock)
    h[:bottle_code] = bottle.bottle_code rescue nil
    h
  end

  def can_sell_stock
    stock
  end

  def tips
    "可用剩余库存：#{can_sell_stock} 瓶。<br/>下单起量：#{min_number} 瓶。自定义包材起量：#{custom_number} 瓶。"
    # "下单起量：#{min_number} 瓶，自定义包材起量：#{custom_number} 瓶。"
  end


  # def show_caps
  #   str = []

  #   str << "酒帽：#{cap.type_code.to_s}（#{cap.texture_des.to_s}）" if cap.present?
  #   str << ['酒帽颜色', cap_color].join('：') if cap_color.present?

  #   if bottle_code.present? && bottle_code.last == 'C'
  #     str << ['酒塞', carton.desc].join('：') if carton.present?
  #   end
  #   str.join('<br/>')
  # end

  def unit_price
    service_price = 0
    if bottle.present?
      _sp = BottleServicePrice.where(bottle_type: bottle.vendor_code).first
      if _sp.present?
        service_price = _sp.price(0)
      end
    end

    [
      bulk_wine.price,
      (cork.price rescue 0),
      (divider.price rescue 0),
      (cap.price rescue 0),
      (bottle.price rescue 0),
      (carton.price / package.to_i rescue 0),
      (service_price / package.to_i rescue 0),
    ].sum
  end

  def self.update_stock(order = nil, _bulk_wine_ids = nil)
    bulk_wine_ids = BulkWine.where(:is_delete => 0, :status => 1).ids
    if order.present?
      bulk_wine_ids = bulk_wine_ids & order.order_productions.pluck(:bulk_wine_id)
    end

    bulk_wine_ids = _bulk_wine_ids if _bulk_wine_ids.present?

    BulkWine.where(:id => bulk_wine_ids).preload(:stock, :stock_logs).map do |bulk_wine|
      sold_count = 0
      first_date = bulk_wine.stock_logs.order('id asc').first.created_at

      order_ids = OrderProduction.where(:bulk_wine_id => bulk_wine.id)
      .where('updated_at > ?', first_date).pluck(:order_id)
      order_ids = Order.where(id: order_ids).where('updated_at > ?', first_date).ids
      OrderProduction.where(:order_id => order_ids, :bulk_wine_id => bulk_wine.id).preload(:order)
      .order('order_id asc')
      .map do |order_pro|
        next if order_pro.order.blank?
        if order_pro.order.status.in?([1, 2, 3, 4, 5])
          sold_count += order_pro.real_num
        end
      end
      args = {
        :sold_count => sold_count,
        :stock => bulk_wine.stock.total_stock - sold_count,
      }
      bulk_wine.stock.update args
    end
  end

  before_save do
    self.custom_number = self.min_number + 1 if self.custom_number.to_i < self.min_number.to_i
  end
end
