# frozen_string_literal: true
class OrderProduction < ApplicationRecord
  belongs_to :order
  has_one :user, :through => :order
  has_one :seller, :through => :order

  belongs_to :bulk_wine
  belongs_to :bulk_wine_stock, :foreign_key => "bulk_wine_id"
  # belongs_to :production

  # packaging
  belongs_to :bottle
  belongs_to :cork
  belongs_to :cap
  belongs_to :divider
  belongs_to :carton

  # is_hb 0 - OEM订单, 1 - 灌装服务
  # produced 0 - 未安排罐, 1 - 已安排灌装, 2 - 无需灌装, 3 - 生产完成
  # shipped 0 - 未发货, 1 - 已发货
  # paid 0 - 未支付, 1 - 已支付

  # PRODUCE_TYPE = {
  #   1 => '灌装备货',
  #   2 => '现货贴标'
  # }.freeze

  PRODUCED = {
    0 => "未排灌装",
    1 => "已排灌装",
    2 => "无需灌装",
    3 => "生产完成",
  }.freeze


  PACKAGES = ["6x750ml", "12x750ml", "24x187ml", "6x1500ml", "1x3000ml", "1x6000ml", "1x9000ml", "1x20000ml"].freeze
  PACKAGE_COUNT = {
    "6x750ml" => 1,
    "12x750ml" => 1,
    "24x187ml" => 0.4,
    "6x1500ml" => 2,
    "1x3000ml" => 4,
    "1x6000ml" => 8,
    "1x9000ml" => 12,
    "1x20000ml" => 26.67,
  }.freeze

  PROVIDERS = {
    0 => '包含',
    1 => '客供',
    2 => '代采',
  }

  # 汇总页面纸箱外包装
  def outer_packing
    [divider_desc, carton_desc].compact.join(' / ')
  end

  def real_num
    (production_num * PACKAGE_COUNT[package]).to_i rescue production_num
  end

  def production_num_show
    return production_num.ts unless PACKAGES.include?(package)
    return production_num.ts if %w[6x750ml 12x750ml].include?(package)

    "#{production_num.ts} ( x #{PACKAGE_COUNT[package]} = #{real_num.ts} )"
  end

  def total_volume
    real_num * 750
  end

  def show_in_order
    strs = [
      is_hb == 1 ? '【灌装服务】' : bulk_wine_desc,
      brand.blank? ? nil : "<b class='text-dark'>[#{brand}]</b>",
      "<b class='text-dark'>#{production_num.ts}</b>",
      "<smal>#{package}</small>",
      too_little.zero? ? nil : "<b class='text-danger'>未到起定量</b>",
    ]

    if order.status == 0 && bulk_wine.present? && bulk_wine.status.zero?
      strs << "<b class='text-danger'>已下架</b>"
    end
    strs.compact.join(' ')
  end

  def produced_show
    OrderProduction::PRODUCED[produced]
  end

  def shipped_show
    return '无需发货' if order.need_delivery.zero?
    {0 => '未发货', 1 => '已发货'}[shipped]
  end

  def paid_show
    {0 => '未支付', 1 => '已支付'}[paid]
  end

  def price_show
    [order.currency_icon, (production_num.to_i * unit_price).ts].join(' ')
  end

  # 附加费用
  def fee_show
    return '/' if fee_name.blank?
    [order.currency_icon, fee, ['(', fee_name, ')'].join].join(' ')
  end

  def total_price_show
    [order.currency_icon, (production_num.to_i * unit_price + fee).ts].join(' ')
  end

  def cap_color_show
    return nil if cap_color == 0
    return nil if cap_color == '空值'
    cap_color
  end

  # def show_cap
  #   return '' if bottle.blank?
  #   if bottle_code.blank?
  #     self.update :bottle_code => bottle.bottle_code
  #   end

  #   str = []
  #   if bottle_code.present? && bottle_code.last == "C"
  #     str << ["木塞", cork_desc.to_s].join("：") if cork_desc.present?
  #     str << "木塞客供" if cork_id == 0
  #   end

  #   if bottle_code.last == "C"
  #     if cap_id == 0
  #       str << '胶帽客供'
  #     elsif cap_desc.present?
  #       str << [ "胶帽", [cap_desc.to_s, cap_color_show].compact.join(' - ')].join("：")
  #     end
  #   else
  #     if cap_id == 0
  #       str << '螺旋盖客供'
  #     elsif cap_desc.present?
  #       str << [ "螺旋盖", [cap_desc.to_s, cap_color_show].compact.join(' - ')].join("：")
  #     end
  #   end

  #   if str.blank?
  #     str << '包材未选择'
  #   end

  #   str.join("，")
  # end

  def cork_print_show
    {0 => '无' ,  1 => '有' }[self.cork_print]
  end

  def boxes
    return 0 if package.to_i < 1
    num = production_num / package.to_i rescue 0
    num += 1 if production_num % package.to_i > 0
    num
  end

  def show_boxes
    str = []
    if divider_id == 0
      str << '分隔板客供'
    else
      str << self.divider_desc
    end

    if carton_id == 0
      str << '纸箱客供'
    else
      str << self.carton_desc
    end

    "纸箱外包装：" + str.join(' / ')
  end

  def service_price
    return 0 if bottle.blank?
    _sp = BottleServicePrice.where(bottle_type: bottle.vendor_code).first
    return 0 if _sp.blank?
    _sp.price(production_num)
  end

  # 包材显示
  def packing_show
    return if bulk_wine.blank?

    bottle_show = self.bottle_code
    bottle_show += ' / ' +Bottle::CUSTOMIZE[self.bottle_customize]
    bottle_show += ' / <small class="text-dark">' + PROVIDERS[bottle_provider] + '</small>' if self.bottle_provider > 0

    if bottle_code.last == "C"
      cork_show = self.cork_desc.to_s
      cork_show += ' / 需要印刷' if self.cork_print == 1
      cork_show += ' / <small class="text-dark">' + PROVIDERS[cork_provider] + '</small>' if self.cork_provider > 0
    end

    cap_show = self.cap_desc.to_s
    cap_show += ' / 需要印刷' if self.cap_print == 1
    cap_show += ' / ' + self.cap_color_show if self.cap_color.present?
    cap_show += ' / <small class="text-dark">' + PROVIDERS[cap_provider] + '</small>' if self.cap_provider > 0

    divider_show = self.divider_desc.to_s
    divider_show += ' / <small class="text-dark">' + PROVIDERS[divider_provider] + '</small>' if self.divider_provider > 0

    carton_show = self.carton_desc.to_s
    carton_show += ' / <small class="text-dark">' + PROVIDERS[carton_provider] + '</small>' if self.carton_provider > 0

    if bottle_code.last == "B"
      html = <<-HTML
      <dl class="dl-horizontal"><dt>瓶型</dt><dd>%s</dd><dt>螺旋盖</dt><dd>%s</dd><dt>分隔板</dt><dd>%s</dd><dt>纸箱</dt><dd>%s</dd>
      </dl>
      HTML
      return html % [bottle_show, cap_show, divider_show, carton_show]
    end

    html = <<-HTML
    <dl class="dl-horizontal"><dt>瓶型</dt><dd>%s</dd><dt>木塞</dt><dd>%s</dd><dt>胶帽</dt><dd>%s</dd><dt>分隔板</dt><dd>%s</dd><dt>纸箱</dt><dd>%s</dd>
    </dl>
    HTML
    return html % [bottle_show, cork_show, cap_show, divider_show, carton_show]
  end

  def total_price
    [
      (bulk_wine.price rescue 0),
      (cork.price rescue 0),
      (divider.price rescue 0),
      (cap.price rescue 0),
      (bottle.price rescue 0),
      (carton.price / package.to_i rescue 0),
      (service_price / package.to_i rescue 0),
    ].sum
  end

  def can_use?
    return false if is_hb == 0 && bulk_wine_desc.blank?
  end

end
