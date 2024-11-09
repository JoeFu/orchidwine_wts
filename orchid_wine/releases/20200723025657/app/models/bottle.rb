# encoding: utf-8
# 瓶子
class Bottle < ApplicationRecord

  # `id` int(11) NOT NULL AUTO_INCREMENT,
  # `cover` varchar(255) DEFAULT NULL,
  # `bottle_code` varchar(255) DEFAULT NULL,
  # `vendor_code` varchar(255) DEFAULT NULL,
  # `seal` int(11) DEFAULT NULL,
  # `height` int(11) DEFAULT NULL,
  # `volume` int(11) DEFAULT NULL,
  # `weight` int(11) DEFAULT NULL,
  # `max_level` int(11) DEFAULT NULL,
  # `shape` varchar(255) DEFAULT NULL,
  # `angle` varchar(255) DEFAULT NULL,
  # `diam` int(11) DEFAULT NULL,
  # `neck_size` varchar(255) DEFAULT NULL,
  # `tray_bottle` int(11) DEFAULT NULL,
  # `created_at` datetime DEFAULT NULL,
  # `updated_at` datetime DEFAULT NULL,
  # `is_delete` tinyint(4) DEFAULT '0',


  CUSTOMIZE = {
    0 => '无定制',
    1 => 'Glass Print',
    2 => 'Laser Graving',
  }

  SEAL = {
    1 => 'C-CK-木塞',
    2 => 'B-BVS-螺旋盖'
  }

  STATUS = {
    0 => '已下架',
    1 => '已上架'
  }

  def status_show
    color = status.zero? ? "warning" : "success"

    html = <<-HTML
    <span class="label label-%s"> %s</span>
    HTML
    return html % [color, BulkWine::STATUS[status]]
  end

  def bottle_code_show
    ["[#{bottle_code}] [#{vendor_code}]", shape].join('-')
  end

  def show_seal
    return '无' if seal.blank?
    seal == 1 ? '木塞' : '螺旋盖'
  end

  def seal_type
    SEAL[seal].split('-').first
  end

  # def self.bottle_codes_nouse
  #   Bottle::BOTTLE_CODE.values - Bottle.where(:is_delete => 1).pluck(:bottle_code)
  # end

  def self.select_options(type = 'C', _bottle = nil, package = '6x750ml')
    # service_prices = BottleServicePrice.service_prices(package.to_i)
    # bottles = self.where(:vendor_code => service_prices.keys, :is_delete => 0, :status => 1)
    bottles = self.where(:is_delete => 0, :status => 1)

    if type.present?
      seal = type == 'C' ? 1 : 2
      bottles = self.where(:is_delete => 0, :status => 1, :seal => seal)
    end

    options = []
    bottles.map do |bottle|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML

      selected = 'selected="selected"' if _bottle.present? && _bottle.id == bottle.id
      show_name = ["[#{bottle.bottle_code}] [#{bottle.vendor_code}]", bottle.shape].join('-')
      options << html % [bottle.id, bottle.price, selected, show_name]
    end
    options.join
  end

  def self.select_options_full
    self.where(:is_delete => 0, :status => 1).order(:seal).map do |bottle|
      [bottle.id, bottle.bottle_code_show]
    end.to_h.invert
  end

  def self.select_options_withid
    self.where(:is_delete => 0).pluck(:id, :bottle_code).to_h.invert
  end

end
