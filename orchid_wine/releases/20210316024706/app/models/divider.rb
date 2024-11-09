# encoding: utf-8
# 分隔板
class Divider < ApplicationRecord

  def self.select_options(package = '6x750ml', divider_id = nil)
    # if package == '6x750ml'
    #   return [
    #     [3, 'FH-6'],
    #     [4, 'HH-6'],
    #   ].to_h.invert
    # elsif package == '12x750ml'
    #   return [
    #     [1, 'FH-12'],
    #     [2, 'HH-12'],
    #   ].to_h.invert
    # elsif package == '24x187ml'
    # else
    #   []
    # end

    return "" if !['6x750ml', '12x750ml'].include?(package)

    options = []
    self.where(:is_delete => 0).where("divider_type like '%?'", package.to_i).map do |divider|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML
      selected = 'selected="selected"' if divider_id == divider.id
      options << html % [divider.id, divider.price, selected, divider.divider_type]
    end
    options.join
  end

  def self.select_options_withid(package = '6x750ml')
    return "" if !['6x750ml', '12x750ml'].include?(package)

    self.where(:is_delete => 0)
    .where("divider_type like '%?'", package.to_i)
    .pluck(:divider_type, :id).to_h
  end

end


# 1 1 FH-12
# 2 2 HH-12
# 3 3 FH-6
# 4 9 HH-6
