# encoding: utf-8
class Order < ApplicationRecord
  belongs_to :user
  has_many :order_productions, -> {where(is_delete: 0)}
  has_many :order_records
  belongs_to :seller, :class_name => "Admin", :foreign_key => "seller_id"

  has_many :order_production_transitions
  has_many :order_production_deliveries

  # 自动创建订单编号
  def self.create_order_number
    if (Order.where(:order_number => "700")).blank?
      now_order_number = "700"
    else
      last_order_number = (Order.where("order_number > 700").order("order_number asc").last).order_number rescue 700
      now_order_number = (last_order_number.to_i + 1).to_s
    end
  end

  SORT = {
    1 => 'OEM订单',
    2 => '灌装服务订单'
  }

  #卖方公司交货码头
  SELLER_ELIVERY_WHARF = {
    1 => "阿德莱德",
    2 => "墨尔本",
  }

  # 交货方式
  DELIVERY_WAY = {
    1 => "EXW（澳洲境内，卖方指定仓库提货，澳元结算）",
    2 => "FOB（澳洲境内，卖方码头交货，澳元结算）",
    3 => "CIF（澳洲境内，买方码头交货，含保险，不含清关，澳元结算）",
    4 => "DDP（澳洲境外，卖方境外仓库完税交货，中国境内，人民币结算）",
  }

  #币种
  CURRENCY = {
    1 => "澳元",
    2 => "人民币",
  }

  # 订单状态
  TAB_STATUS = {
    1 => "预订单",
    2 => "财务复核",
    3 => "未排灌装",
    4 => "已排灌装",
    5 => "待付尾款",
    6 => "已完成",
  }

  STATUS_SHOW = {
    0 => "购物车",
    1 => "预订单",
    2 => "财务复核",
    3 => "未排灌装",
    4 => "生产完成",
    5 => "已发货",
    7 => "已撤销",
    # 8 => "超时取消",
    # 10 => "已过期",
    19 => '已拆单',
  }

  def status_show
    Order::STATUS_SHOW[status]
  end

  def seller_name
    seller.true_name rescue "待确定"
  end

  def currency_icon
    currency == 2 ? "￥" : "$"
  end

  def currency_total_price
    [Order::CURRENCY[currency], "(", currency_icon, ")：", total_price.ts].join()
  end

  def update_total_price
    total = order_productions.map do |op|
      op.production_num.to_i * op.unit_price + op.fee
    end.sum

    self.update :total_price => total
  end

  def a_link
    # if split_from.blank?
    html = <<-HTML
    <a class="btn-link" href="/admin/orders/%s">%s</a>
    HTML
    return html % [id, version == 1 ? order_number : [order_number, version].join("_v")]
    # end

    # html = <<-HTML
    # <a class="btn-link" href="/admin/orders/%s">%s(来自拆单)</a>
    # HTML
    # return html % [split_from, version == 1 ? order_number : [order_number, version].join("_v")]
  end

  def status_tmp?
    self.status.in?([1 + 50, 2 + 50])
  end

  def copy
    args = self.attrs.except(:id)
    # '编辑创建的临时订单状态编号' status += 50
    args[:status] += 50

    order = Order.create args
    order_productions.map do |order_production|
      order_production_args = order_production.attrs.except(:id)
      order_production_args[:order_id] = order.id
      OrderProduction.create order_production_args
    end
    order
  end

  def seller_default?
    self.seller_company_name == Const::ORCHID_INFO[:company_name] &&
      self.seller_company_contacts == Const::ORCHID_INFO[:company_contacts] &&
      self.seller_company_address == Const::ORCHID_INFO[:company_address] &&
      self.seller_company_telephone == Const::ORCHID_INFO[:company_telephone] &&
      self.seller_company_email == Const::ORCHID_INFO[:company_email]
  end

  def export_default?
    self.export_company_name == Const::ORCHID_INFO[:company_name] &&
      self.export_company_contacts == Const::ORCHID_INFO[:company_contacts] &&
      self.export_company_address == Const::ORCHID_INFO[:company_address] &&
      self.export_company_telephone == Const::ORCHID_INFO[:company_telephone] &&
      self.export_company_email == Const::ORCHID_INFO[:company_email]
  end

  # 拆单
  def split
    order_productions.map do |order_production|
      args = self.attrs.except(:id, :created_at, :updated_at)
      args[:split_from] = self.id
      args[:total_bottle_num] = order_production.production_num

      _order = Order.create args
      order_production.update order_id: _order.id
    end

    self.update :status => 19
  end

  # 把灌装服务拆出来
  def hb_split
    order_ids = []
    order_productions.where(is_hb: 1).map do |order_production|
      args = self.attrs.except(:id, :created_at, :updated_at)
      args[:total_bottle_num] = order_production.production_num
      order = Order.create args
      order_ids << order.id
      order_production.update order_id: order.id
    end

    _order_productions = OrderProduction.where(order_id: self.id)
    if _order_productions.blank?
      self.destroy
    else
      self.update :total_bottle_num => _order_productions.sum(:production_num)
      order_ids << self.id
    end
    order_ids
  end

  def to_transitions
    # return if !status.in?([2,3])
    return if OrderProductionTransition.where(order_id: self.id).present?
    return if OrderProductionDelivery.where(order_id: self.id).present?

    order_productions.map do |order_production|
      args = {
        order_id: order_production.order_id,
        order_number: self.order_number,
        user_id: self.user_id,
        order_production_id: order_production.id,
        num: order_production.production_num,
      }

      OrderProductionTransition.create args
    end
  end

  def clear_nil_production
    return if status != 0
    OrderProduction.where(order_id: self.id, production_num: 0).delete_all
  end

  # 2019 带走预订单
  # def self.clean_pre_orders
  #   stocks = {}
  #   order_ids = self.where(:status => 1).ids
  #   OrderProduction.where(:order_id => order_ids)
  #   .select('bulk_wine_id, sum(production_num) as count')
  #   .group(:bulk_wine_id)
  #   .map do |order_production|
  #     stocks[order_production.bulk_wine_id] = order_production.count
  #   end

  #   enough_bulk_wine_ids = []
  #   BulkWineStock.where(:bulk_wine_id => stocks.keys).map do |stock|
  #     if stock.min_number <= stocks[stock.bulk_wine_id]
  #       enough_bulk_wine_ids << stock.bulk_wine_id
  #     end
  #   end

  #   Order.where(:id => order_ids).map do |order|
  #     is_hbs = order.order_productions.pluck(:is_hb).uniq
  #     # 全是灌装，直接通过
  #     if is_hbs == [1]
  #       order.update :status => 12
  #       next
  #     end

  #     bulk_wine_ids = order.order_productions.pluck(:bulk_wine_id)
  #     result = bulk_wine_ids & enough_bulk_wine_ids
  #     next if result.blank? && is_hbs == [0]
  #     # 直接通过
  #     if bulk_wine_ids == result
  #       order.update :status => 12
  #     else
  #       # 拆单通过
  #       order.split
  #       Order.where(:split_from => order.id).map do |_order|
  #         order_production = _order.order_productions.first
  #         if order_production.is_hb == 1 || enough_bulk_wine_ids.include?(order_production.bulk_wine_id)
  #           _order.update :status => 12
  #         end
  #       end
  #     end
  #   end

  #   self.merge_orders
  # end

  # 提交订单时验证库存
  def check_stock
    out_of_stock = false
    self.order_productions.preload(:bulk_wine_stock).map do |order_production|
      next if order_production.is_hb == 1
      if order_production.bulk_wine_stock.blank? ||
          order_production.bulk_wine.status == 0 ||
          order_production.bulk_wine_stock.can_sell_stock < order_production.production_num
        out_of_stock = true
        next
      end
    end

    !out_of_stock
  end

  # 财务复核的时候合并已拆分的订单
  def self.merge_orders
    split_froms = Order.where(:status => 2).where.not(:split_from => nil).pluck(:split_from).uniq
    # 部分合并
    split_froms.map do |split_from|
      order = Order.where(:status => 2, :split_from => split_from).first
      Order.where(:status => 2, :split_from => split_from)
      .where.not(id: order.id).map do |_order|
        _order.order_productions.update :order_id => order.id
        _order.destroy
      end
    end

    # 除去待拆单里面的，就是全都已经带走了订单了
    # split_froms -= Order.where(split_from: split_froms, status: 1).pluck(:split_from).uniq
    # 上面已经合并了，这里只需要将产品恢复到原订单
    split_froms.map do |split_from|
      order = Order.find(split_from)
      Order.where(split_from: split_from, status: 2).map do |_order|
        _order.order_productions.update :order_id => order.id
        _order.destroy
      end
      total_bottle_num = OrderProduction.where(order_id: order.id).sum(:production_num)
      order.update :status => 2, :total_bottle_num => total_bottle_num
    end
    true
  end


  def self.sales_statistics(start_date, end_date, sort = 1)
    conditions, values = [], []
    # start_date = start_date.to_date
    # end_date = end_date.to_date

    if sort == 1
      conditions << 'date_submit >= ?'
      conditions << 'date_submit <= ?'
    elsif sort == 2
      # 财务复核
      conditions << 'date_confirm >= ?'
      conditions << 'date_confirm <= ?'
    elsif sort == 3
      # 排产中
      conditions << 'date_recheck >= ?'
      conditions << 'date_recheck <= ?'
    end

    values << start_date
    values << end_date

    conditions << 'status in (0, 1, 12, 2, 3, 4)'
    result = {}
    orders = Order.where(conditions.join(' and '), *values).preload(:seller, :order_productions)
    bulk_wine_ids = OrderProduction.where(order_id: orders.ids).pluck(:bulk_wine_id)
    stocks = BulkWineStock.where(id: bulk_wine_ids).preload(:bulk_wine, :bottle, :cork, :cap, :divider, :carton)
    .map do |stock|
      [stock.id, stock]
    end.to_h

    orders.map do |order|
      seller_name = order.seller.true_name
      result[seller_name] ||= {}
      order.order_productions.preload(:bulk_wine).map do |order_production|
        next if order_production.is_hb == 1
        next if stocks[order_production.bulk_wine_id].blank?

        stock = stocks[order_production.bulk_wine_id]
        result[seller_name][stock.id] ||= {
          bulk_wine_name: stock.bulk_wine.desc,
          total: 0,
          price: stock.bulk_wine.price,
          cost: stock.bulk_wine.cost,
        }

        result[seller_name][stock.id][:total] += order_production.production_num
      end
    end
    result
  end

  # 状态编码变更
  # 版本更新的使用一次
  # def self.init_status_update
  #   Order.where(status: 4).update_all status: 5
  #   Order.where(status: 3).update_all status: 4
  #   Order.where(status: 2).update_all status: 3
  #   Order.where(status: 12).update_all status: 2
  #   Order.where(status: 1).update_all status: 2
  #   Order.merge_orders
  # end

  # def self.update_order_status
  #   Order.where(status: 0, order_number: [2372,2394,2390,2380,2368,2369,2276]).map do |order|
  #     p [order.order_number, order.check_stock]
  #     if order.check_stock
  #       args = {
  #         :status => 1,
  #         :date_submit => Time.now
  #       }
  #       order.update args

  #       # 订单记录表添加提交订单记录
  #       args = {
  #         :order_id => order.id,
  #         :operate_id => 1,
  #         :operate_rank => 1, #1-管理员 2-客户
  #         :operate_type => 1, #提交订单
  #       }
  #       OrderRecord.create args
  #       BulkWineStock.update_stock(order)
  #       GmailCpts.order_new(order) rescue nil
  #     end
  #   end
  # end

  # 预确定订单 14 天过期。
  def self.timeout
    Order.where(status: 1).where('date_submit < ?', 14.day.ago).map do |order|
      # 订单记录表添加撤销订单记录
      OrderRecord.create order_id: order.id, operate_type: 9
      order.update status: 0, date_submit: nil
      BulkWineStock.update_stock order
      GmailCpts.order_cancel(order)
    end
  end

  # def self.fix_data
  #   ids = where(status: 4).ids
  #   OrderProduction.where(order_id: ids).map do |order_production|
  #    p [order_production.order_id, order_production.id, order_production.produced]
  #   end
  # end
end
