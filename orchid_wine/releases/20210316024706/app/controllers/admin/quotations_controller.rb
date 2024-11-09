class Admin::QuotationsController < Admin::ApplicationController
  before_action :find_model

  def index
    # OrderProduction.where(:is_hb => 0, :bulk_wine_code => nil).delete_all
    conditions, values = conditions_values
    @orders = Order.where(conditions.join(' and '), *values)
    .preload(:user, :seller, :order_productions)
    .limit(Const::ADMIN_PAGE_SIZE)
    .order('id desc')
    .page(params[:page])

    @orders_ids = Order.where(conditions.join(' and '), *values).ids

    @bulk_wine_codes = {}
    @bulk_wine_stocks = {}
    OrderProduction.where(order_id: @orders_ids)
    .preload(:bulk_wine, :bulk_wine_stock)
    .map do |op|
      next if op.is_hb == 1
      next if op.bulk_wine.blank?

      @bulk_wine_codes[op.bulk_wine_id] ||= op.bulk_wine.desc
      @bulk_wine_stocks[op.bulk_wine_id] = op.bulk_wine_stock.stock
    end

    @seller_ids = Order.where(conditions.join(' and '), *values).pluck(:seller_id).uniq
  end

  def create
    user = User.find(params[:user_id]) rescue nil
    if user.blank?
      flash[:error] = '请先选择客户！'
      return redirect_to request.referer
    end

    params[:seller_id] = @admin_session.id
    params[:quotation] = params
    @order = Order.create params.require(:quotation).permit(*Order.attrs)

    return redirect_to "/admin/orders/#{@order.id}/edit"
  end

  def update
    user = User.find(params[:user_id]) rescue nil
    if user.blank?
      flash[:error] = '请先选择客户！'
      return redirect_to request.referer
    end

    params[:quotation] = params
    @order.update params.require(:quotation).permit(*Order.attrs)
    flash[:success] = '编辑成功'
    return redirect_to '/admin/quotations'
  end

  def export
    conditions, values = conditions_values

    orders = Order.where(conditions.join(' and '), *values)
    order_ids = orders.ids
    user_ids = orders.pluck(:user_id).uniq
    admin_ids = orders.pluck(:seller_id).uniq

    users = User.where(id: user_ids).map { |user| [user.id, user] }.to_h
    sellers = Admin.where(id: admin_ids).map { |admin| [admin.id, admin] }.to_h

    order_productions = OrderProduction.where(:order_id => order_ids).preload(:order, :bulk_wine, :bottle, :cork, :cap, :carton)
    datas = [
      [
        "订单编号","下单日期","销售人员","客户名称",
        "产品类型","产品编码","产品描述","数量（瓶数）","包装类型","箱数合计",
        "产品酒标名称","瓶型","酒瓶要求","木塞","木塞印刷","胶帽","胶帽类型","螺旋盖","螺旋盖类型","分隔板","纸箱",
        "状态","状态变更时间","操作变更","币种","来源","备注"
      ],
    ]
    order_productions.order('order_id asc').map do |o_product|
      data_attr = []
      if o_product.order.present? && o_product.bulk_wine.present?
        order = o_product.order

        data_attr << order.order_number
        data_attr << time_human(order.created_at)

        data_attr << (o_product.seller.true_name rescue '')
        data_attr << (o_product.user.name rescue '')

        data_attr << o_product.bulk_wine.sort_show
        data_attr << o_product.bulk_wine.code
        data_attr << o_product.bulk_wine.desc

        data_attr << o_product.production_num.to_i
        data_attr << o_product.package
        data_attr << o_product.boxes
        data_attr << o_product.brand

        data_attr << o_product.bottle_code
        data_attr << Bottle::CUSTOMIZE[o_product.bottle_customize]

        data_attr << o_product.cork_desc.to_s
        data_attr << o_product.cork_print_show

        if o_product.bottle_code.last == "C"
          data_attr << o_product.cap_desc.to_s
          data_attr << o_product.cap_color
          data_attr << ''
          data_attr << ''
        else
          data_attr << ''
          data_attr << ''
          data_attr << o_product.cap_desc.to_s
          data_attr << o_product.cap_color
        end
        data_attr << o_product.divider_desc.to_s
        data_attr << o_product.carton_desc.to_s

        providers = []
        providers << ["酒瓶", OrderProduction::PROVIDERS[o_product.bottle_provider]].join(':')
        if o_product.bottle_code.last == "C"
          providers << ["木塞", OrderProduction::PROVIDERS[o_product.cork_provider]].join(':')
          providers << ["胶帽", OrderProduction::PROVIDERS[o_product.cap_provider]].join(':')
        else
          providers << ["螺旋盖", OrderProduction::PROVIDERS[o_product.cap_provider]].join(':')
        end
        providers << ["分隔板", OrderProduction::PROVIDERS[o_product.divider_provider]].join(':')
        providers << ["纸箱", OrderProduction::PROVIDERS[o_product.carton_provider]].join(':')

        data_attr << order.status_show

        date = time_human(order.updated_at)
        if order.date_confirm.present?
          date = time_human(order.date_confirm)
        end
        if order.date_recheck.present?
          date = time_human(order.date_recheck)
        end
        data_attr << date
        data_attr << time_human(order.updated_at)

        currency = (Order::CURRENCY[order.currency] rescue '')
        data_attr << currency

        data_attr << providers.join('; ')
        data_attr << o_product.remark.to_s
      end
      datas << data_attr
    end

    sname = "TWS-ShoppingCart-" + Time.now.strftime('%Y%m%d%H%M')
    write_xlsx(datas,sname,:string)
    send_file "#{Const::UPLOAD_EXCEL}/#{sname}.xlsx"
  end

  private

  def conditions_values
    conditions, values = [], []

    if params[:bulk_wine_sort_id].to_i > 0 ||
        params[:bulk_wine_vendor_id].to_i > 0 ||
        params[:bulk_wine_variety_id].to_i > 0 ||
        BulkWineYear.options.include?(params[:bulk_wine_year])

      bk_conditions, bk_values =[], []
      if params[:bulk_wine_sort_id].to_i > 0
        bk_conditions << 'sort_id = ?'
        bk_values << params[:bulk_wine_sort_id].to_i
      end

      if params[:bulk_wine_vendor_id].to_i > 0
        bk_conditions << 'vendor_id = ?'
        bk_values << params[:bulk_wine_vendor_id].to_i
      end

      if params[:bulk_wine_variety_id].to_i > 0
        bk_conditions << 'variety_id_one = ? or variety_id_two = ? or variety_id_three = ?'
        bk_values << params[:bulk_wine_variety_id].to_i
        bk_values << params[:bulk_wine_variety_id].to_i
        bk_values << params[:bulk_wine_variety_id].to_i
      end

      if BulkWineYear.options.include?(params[:bulk_wine_year])
        bk_conditions << 'year = ?'
        bk_values << params[:bulk_wine_year]
      end

      bulk_wine_ids = BulkWine.where(bk_conditions.join(' and '), *bk_values).ids
      order_ids = OrderProduction.where(bulk_wine_id: bulk_wine_ids).pluck('order_id')
      conditions << 'id in (?)'
      values << order_ids.compact.uniq
    end

    if params[:bulk_wine_id].to_i > 0
      @bulk_wine = BulkWine.find(params[:bulk_wine_id].to_i)
      order_ids = OrderProduction.where(bulk_wine_id: @bulk_wine.id).pluck('order_id')
      conditions << 'id in (?)'
      values << order_ids.compact.uniq
    end

    if params[:user_name].present?
      user_ids = User.where('name like ?', "%#{params[:user_name]}%").ids
      conditions << 'user_id in (?)'
      values << user_ids
    end

    if (sort = params[:sort].to_i).present? && sort.in?([1,2])
      conditions << 'sort = ?'
      values << sort
    end

    if @admin_session.role == 2
      conditions << "seller_id = #{@admin_session.id}"
    elsif params[:seller_id].present?
      conditions << "seller_id = ?"
      values << params[:seller_id]
    end

    conditions << 'status = 0'
    [conditions, values]
  end

  def find_model
    @order = Order.find(params[:id]) if params[:id]
  end
end
