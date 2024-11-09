class Admin::OrderTablesController < Admin::ApplicationController
  before_action :table_order_productions
  include Admin::OrdersHelper
  def data
    @orders = []
    @order_productions.map do |order_production|
      next if order_production.bulk_wine.blank?

      order = order_production.order
      args = {
        id: order.id,
        order_number: order.a_link,
        user_id: order.user_id,
        user_name: order.user.name,
        sort: order_production.bulk_wine.sort_show,
        bulk_wine: order_production.show_in_order,
        bottle_code: order_production.bottle_code,
        outer_packing: order_production.outer_packing,
        seller_name: order.seller.true_name,
        status_show: order.status_show,
        produced: order_production.produced_show,
        shipped: order_production.shipped_show,
        paid: order_production.paid_show,
        ocean_dest_name: order.ocean_dest_name,
      }

      if can?(:show, :User)
        args[:user_name] = order.user.a_link
      end

      if order.status.in?([3, 4])
        args[:status_show] = order_production.produced_show
      end

      if params[:search_status].to_i == 4
        args[:status_show] = order_production.produced_show
      end
      if params[:status].to_i.in?([3, 4])
        if can?(:produced, :Order)
          if order_production.produced == 0
            if can?(:cancel_recheck, :Order)
              if order.status == 3
                args[:cancel_recheck] = "<a href=\"/admin/orders/#{order.id}/cancel_recheck\" data-option=\"撤回复核\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-warning\"><i class=\"btn-label ion-arrow-return-left\"></i> 撤回复核</a>"
              else
                args[:cancel_recheck] = "-"
              end
            end
            args[:produced] = "<a href=\"/admin/orders/#{order_production.id}/produced?produced=1\" data-option=\"安排灌装\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-info\"><i class=\"btn-label ion-checkmark-circled\"></i> 安排灌装</a>"
            args[:produced_no_need] = "<a href=\"/admin/orders/#{order_production.id}/produced?produced=2\" data-option=\"无需灌装\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-warning\"><i class=\"btn-label ion-checkmark-circled\"></i> 无需灌装</a>"
          elsif order_production.produced == 1
            args[:produced] = "<a href=\"/admin/orders/#{order_production.id}/produced?produced=3\" data-option=\"生产完成\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-info\"><i class=\"btn-label ion-checkmark-circled\"></i> 生产完成</a>"
            args[:cancel_produced] = "<a href=\"/admin/orders/#{order_production.id}/produced?produced=0\" data-option=\"撤回灌装\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-warning\"><i class=\"btn-label ion-arrow-return-left\"></i> 撤回灌装</a>"
          end
        end
      end
      if params[:status].to_i.in?([5])
        args[:paid] = '未支付'
        if order_production.paid.zero?
          if order_production.shipped.zero?
            args[:paid] = '-'
          else
            if can?(:pay, :Order)
              args[:paid] = "<a href=\"/admin/orders/#{order_production.id}/pay\" data-option=\"已支付尾款\" class=\"mtd-patch btn btn-xs btn-rounded btn-labeled btn-info\"><i class=\"btn-label ion-checkmark-circled\"></i> 已支付尾款</a>"
            end
          end
        end
      end
      @orders << args
    end
  end
end
