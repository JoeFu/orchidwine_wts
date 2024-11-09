# encoding: utf-8
# 螺旋盖 和 胶帽
class Cap < ApplicationRecord

  def self.select_options(type_code = 'C', cap_id = nil)
    options = []
    caps = self.where(:is_delete => 0, :type_code => type_code)
    if type_code == 'All'
      caps = self.where(:is_delete => 0)
    end

    caps.map do |cap|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML
      selected = 'selected="selected"' if cap_id == cap.id
      options << html % [cap.id, cap.price, selected, cap.desc]
    end
    if type_code == 'All'
      options = ['<option value="0" data-price="0">无</option>'] + options
    end
    options.join
  end

  def desc
    [self.type_des, '（', self.texture_des, '）'].join
  end
end