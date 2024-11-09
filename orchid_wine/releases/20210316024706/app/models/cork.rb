# encoding: utf-8
# 木塞
class Cork < ApplicationRecord

  def self.select_options(cork_id = nil)
    options = []
    self.where(:is_delete => 0).map do |cork|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML
      selected = 'selected="selected"' if cork_id == cork.id
      options << html % [cork.id, cork.price, selected, cork.desc]
    end
    options.join
  end

  def desc
    [self.texture_code, '（', self.texture_des, '）'].join
  end
end
