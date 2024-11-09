class Admin::OrdersNewController < Admin::ApplicationController

  def index
    @order = Order.find(params[:order_id]) if params[:order_id].present?
    sort = 1
    if params[:sort].present?
      sort = params[:sort].to_i
      sort = 1 if !sort.in?([1,2])
    end

    @order ||= Order.new sort: sort, auto_confirm: params[:auto_confirm].to_i

    @form_action = @order.id.present? ? "/admin/orders/#{@order.id}" : "/admin/orders"
    @form_method = @order.id.present? ? :put : :post

    @title = '创建订单到购物车'
    if @order.auto_confirm == 1
      @title = '直接购买OEM产品'
    end

    session[:list_url] = "/admin/quotations"
  end
end
