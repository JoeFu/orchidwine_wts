# encoding: utf-8
# 纸箱
class Carton < ApplicationRecord

  def self.select_options(package = '6x750ml', carton_id = nil)
    # if package == '6x750ml'
    #   return [
    #     [8, '6支装BrownBox'],
    #     [5, '6支装Customer Supply'],
    #     [3, '6支装Print'],
    #     [1, '6支装WBox'],
    #   ].to_h.invert
    # elsif package == '12x750ml'
    #   return [
    #     [9, '12支装BrownBox'],
    #     [6, '12支装Customer Supply'],
    #     [4, '12支装Print'],
    #     [2, '12支装WBox'],
    #   ].to_h.invert
    # elsif package == '24x187ml'
    #   return [[7, "24支装187ml Brown"]].to_h.invert
    # else
    #   []
    # end

    return "" if !['6x750ml', '12x750ml', '24x187ml', '24x600ml'].include?(package)

    options = []
    self.where(:is_delete => 0, :bottle_number => package.to_i).map do |carton|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML
      selected = 'selected="selected"' if carton_id == carton.id
      options << html % [carton.id, carton.price, selected, carton.desc]
    end
    options.join
  end

  CODE_TO_ID = {
    1 => 1,
    2 => 2,
    3 => 3,
    4 => 4,
    8 => 5,
    9 => 6,
    24 => 7,
    5 => 8,
    6 => 9,
  }
end

# 1 1 6支装WBox 2017-01-19 08:01:43 2017-06-27 20:26:23 WBox  6 0
# 2 2 12支装WBox  2017-01-19 08:01:43 2017-06-27 20:26:53 WBox  12  0
# 3 3 6支装Print  2017-01-19 08:01:43 2017-06-27 20:27:15 Print 6 0
# 4 4 12支装Print 2017-01-19 08:01:43 2017-06-27 20:27:29 Print 12  0
# 5 8 6支装Customer Supply  2017-01-19 08:01:43 2019-04-07 18:04:43 Customer Supply 6 0
# 6 9 12支装Customer Supply 2017-01-19 08:01:43 2019-04-07 18:04:48 Customer Supply 12  0
# 7 24  24支装187ml Brown 2019-01-28 16:45:04 2019-01-28 18:23:27 187ml Brown 24  0
# 8 5 6支装BrownBox 2019-01-28 17:59:42 2019-01-28 18:02:00 BrownBox  6 0
# 9 6 12支装BrownBox  2019-01-28 17:59:58 2019-01-28 18:02:09 BrownBox  12  0
