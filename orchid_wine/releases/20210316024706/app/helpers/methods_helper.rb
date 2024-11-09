# encoding: utf-8
module MethodsHelper
  # 以元为单位保留1位小数可读余额
  def int_float(num, scale=2)
    return if num.blank?
    sprintf("%.#{scale}f", (num.to_i * 0.01).round(scale))
  end

  def float_int(num)
    return if num.blank?
    num = num.to_s
    arr = num.split('.')
    first = arr.first
    last = arr.last[0..1]
    last = '00' if arr.size == 1

    last += '0' if last.size == 1
    [first,last].join.to_i
  end

  def time_human(num)
    num.strftime("%F %H:%M") rescue '-'
  end

  def time_shot(num)
    num.to_time.strftime("%Y/%m/%d") rescue '-'
  end

  def date_dot(num)
    num.to_date.strftime("%Y.%m.%d") rescue '-'
  end

  def last_page
    url = env['HTTP_REFERER'].split('?').first
    url + "?page=#{params[:page].to_i - 1}"
  end

  def img_src(str, default = 'noimg')
    return "/img/#{default}.png" if str.blank?
    str
  end

  def img_tag(str)
    return if str.blank?
    "<img src='#{str}'/>"
  end

  def b2M(num)
    return 0 if num.blank?
    return 0 if (num = num.to_i).zero?

    if num < 1000000
      return sprintf("%.#{2}f K", ((num * 0.001)).round(2))
    end

    sprintf("%.#{2}f M", ((num * 0.000001)).round(2))
  end

  def greeting
    nowtime = (Time.now.strftime("%H")).to_i
    greet = ''
    # if nowtime >= 1 && nowtime < 12
    #   greet = '早上好'
    # elsif nowtime >= 12 && nowtime < 18
    #   greet = '下午好'
    # elsif nowtime >= 18 && nowtime < 24
    #   greet = '晚上好'
    # end
    if nowtime < 8
      greet = '早上好'
    elsif nowtime < 11
      greet = '上午好'
    elsif nowtime < 13
      greet = '中午好'
    elsif nowtime < 18
      greet = '下午好'
    else
      greet = '晚上好'
    end
    return greet
  end

end