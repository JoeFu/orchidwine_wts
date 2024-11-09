# encoding: utf-8
class Delivery < ApplicationRecord

  has_many :order_production_deliveries, :class_name => "OrderProductionDelivery"
  has_many :order_productions, :through => :order_production_deliveries

  has_many :containers

  # export_company_name 出口方公司名称
  # export_company_contacts 出口方联系人
  # export_company_telephone 出口方电话
  # export_company_email 出口方电子邮箱
  # export_company_address 出口方地址
  # import_company_name 进口方公司名称
  # import_company_contacts 进口方联系人
  # import_company_telephone 进口方电话
  # import_company_email 进口方电子邮箱
  # import_company_address 进口方地址

  # shipping_company
  # shipping_company_telephone

  STATUS = {
    1 => '预约仓位',
    2 => '已发货',
    # 3 => '已完成'
  }
  STATUS_ICON = {
    1 => 'ion-clipboard',
    2 => 'ion-navigate',
    3 => 'ion-locked',
  }


  COTTON_INSULATION = {
    # 0 => '不需要',
    # 1 => 'HB安装',
    # 2 => '货代安装',
    # 3 => '第三方灌装厂安装',

    0 => 'No Liner（不需要）', #
    1 => 'Habour Bottling supplied（HB 安装）', #
    2 => 'Others Supplied（其他）', #
  }


  def status_show
    Delivery::STATUS[status]
  end

  def a_link
    html = <<-HTML
    <a class="btn-link" href="/admin/deliveries/%s"> %s</a>
    HTML
    html % [id, booking_number]
  end

  def shipping_company_show
    [
      ['货代', shipping_company].join('：'),
      ['出口', export_company_name].join('：'),
      ['进口', import_company_name].join('：')
    ].join('<br/>')
  end

  def cutoff_datetime
    cutoff_date.strftime('%H:%M') rescue nil
  end

  # def order_production_ids
  #   order_production_deliveries.pluck(:order_production_id)
  # end

  def to_transition(container_id = nil)
    opds = if container_id.nil?
      order_production_deliveries
    else
      order_production_deliveries.where(container_id: container_id)
    end

    opds.map do |order_production_delivery|
      order_production_transition = OrderProductionTransition.where(order_production_id: order_production_delivery.order_production_id).first
      if order_production_transition.present?
        order_production_transition.num += order_production_delivery.num
        order_production_transition.save
      else
        args = order_production_delivery.attrs.slice(:order_id, :order_number, :user_id, :order_production_id, :num)
        OrderProductionTransition.create args
      end
      order_production_delivery.delete
    end
  end

  def update_split
    order_ids = OrderProductionDelivery.where(delivery_id: self.id).pluck(:order_id).uniq
    order_ids.map do |order_id|
      order_transition = OrderProductionTransition.where(order_id: order_ids)

      delivery_ids = OrderProductionDelivery.where(order_id: order_id).where.not(delivery_id: self.id).pluck(:delivery_id)
      # 只有一种可能，is_split = 0，那就是transition和其他delivery都不存在的时候
      if order_transition.blank? && delivery_ids.blank?
        OrderProductionDelivery.where(delivery_id: self.id, order_id: order_id).update_all :is_split => 0
        next
      end

      # 从1开始循环，遇到不存在的编号就可以了
      split = 1
      used_splits = OrderProductionDelivery.where(order_id: order_id).where.not(delivery_id: self.id).pluck(:is_split).uniq
      while used_splits.include?(split)
        split += 1
      end

      OrderProductionDelivery.where(delivery_id: self.id, order_id: order_id).update_all :is_split => split
    end
  end

  def update_total_bottle_num
    total = OrderProductionDelivery.where(delivery_id: self.id).pluck(:num).sum
    self.update total_bottle_num: total
  end

  def update_order_status
    order_ids = order_production_deliveries.pluck(:order_id)
    order_ids.map do |order_id|
      next if OrderProductionTransition.where(order_id: order_id).present?
      delivery_ids = OrderProductionDelivery.where(order_id: order_id).pluck(:delivery_id)
      next if Delivery.where(id: delivery_ids, status: 1).present?
      Order.find(order_id).update :status => 5
    end

    order_production_deliveries.map do |opd|
      next if OrderProductionTransition.where(order_production_id: opd.order_production_id).present?
      delivery_ids = OrderProductionDelivery.where(order_production_id: opd.order_production_id).pluck(:delivery_id)
      next if Delivery.where(id: delivery_ids, status: 1).present?
      OrderProduction.find(opd.order_production_id).update shipped: 1
    end
  end

  def can_shipped?
    (order_productions.pluck(:produced).uniq & [0, 1]).blank?
  end

  def self.counts
    self.group(:status)
    .select('status, count(*) as count')
    .map { |d| [d.status, d.count] }.to_h
  end

  # def self.back_transitions
  #   order_ids = OrderProductionTransition.pluck(:order_id)
  #   order_ids = Order.where(id: order_ids, status: [0, 1, 12, 7]).ids
  #   return false if OrderProductionDelivery.where(order_id: order_ids).present?
  #   OrderProductionTransition.where(order_id: order_ids).delete_all

  #   order_ids = []
  #   OrderProductionTransition.all.map do |opt|
  #     order_ids << opt.order_id if opt.order_production.blank?
  #   end

  #   return false if OrderProductionDelivery.where(order_id: order_ids).present?
  #   OrderProductionTransition.where(order_id: order_ids).delete_all
  #   Order.where(id: order_ids).map do |order|
  #     order.to_transitions
  #   end

  #   [
  #     {order_id: 1142, order_production_id: 5903, old_order_production_id: 5620},
  #     {order_id: 1142, order_production_id: 5904, old_order_production_id: 5621},
  #     {order_id: 1142, order_production_id: 5905, old_order_production_id: 5622},
  #     {order_id: 1142, order_production_id: 5906, old_order_production_id: 5623},
  #     {order_id: 1190, order_production_id: 5963, old_order_production_id: 5540},
  #     {order_id: 1190, order_production_id: 5964, old_order_production_id: 5541},
  #     {order_id: 1288, order_production_id: 6075, old_order_production_id: 5657},
  #     {order_id: 1295, order_production_id: 5961, old_order_production_id: 5785},
  #     {order_id: 1295, order_production_id: 5962, old_order_production_id: 5786},
  #     {order_id: 1296, order_production_id: 5948, old_order_production_id: 5877},
  #     {order_id: 1296, order_production_id: 5949, old_order_production_id: 5878},
  #     {order_id: 1296, order_production_id: 5950, old_order_production_id: 5879},
  #     {order_id: 1296, order_production_id: 5951, old_order_production_id: 5880},
  #     {order_id: 1296, order_production_id: 5952, old_order_production_id: 5881},
  #     {order_id: 1296, order_production_id: 5953, old_order_production_id: 5882},
  #     {order_id: 1534, order_production_id: 6376, old_order_production_id: 6134},
  #     {order_id: 1534, order_production_id: 6377, old_order_production_id: 6181},
  #   ].map do |args|
  #     opd = OrderProductionDelivery.where(order_id: args[:order_id], order_production_id: args[:old_order_production_id]).first
  #     next if opd.blank?
  #     opd.update order_production_id: args[:order_production_id]
  #   end

  #   nil
  # end

  # def self.fix_data
  #   # ids = []
  #   # OrderProductionTransition.all.map do |order_production_transition|
  #   #   next if order_production_transition.order_id.blank?
  #   #   order_productions_ids = order_production_transition.order.order_productions.ids
  #   #   if !order_production_transition.order_production_id.in?(order_productions_ids)
  #   #     ids << order_production_transition.order_id
  #   #   end
  #   # end

  #   # Order.where(id: ids).map do |order|
  #   #   order.order_production_transitions.map{|t| t.delete}
  #   #   order.to_transitions
  #   # end
  #   order_ids = [1716, 1834, 1891, 1918, 1943, 2042]
  #   d_order_ids = OrderProductionTransition.where(order_id: order_ids).pluck(:order_id)
  #   ids = order_ids - d_order_ids
  #   p ids
  #   Order.where(id: ids).map do |order|
  #     order.to_transitions
  #   end
  # end
end
