# encoding: utf-8
class Admin::OrdersController < Admin::ApplicationController
  skip_before_action :current_ability, :only => [:print]
  before_action :find_model

  before_action :table_order_productions, :only => [:index, :export]
  before_action :order_counter, :only => [:index]

  include Admin::OrdersHelper

  def index
    # CLAER NIL OrderProduction
    # OrderProduction.where(:is_hb => 0, :bulk_wine_code => nil).delete_all

    if params[:status].present? && params[:status].to_i.in?([1,2])
      order_ids = @order_productions.pluck(:order_id)
      @orders = Order.where(id: order_ids).order('id desc')
      .preload(:user, :seller)
      .limit(Const::ADMIN_PAGE_SIZE)
      .page(params[:page])
    end

    return if params[:status].present? && params[:status].to_i != 0
    # ============================================================
    # 以下是订单汇总页面瓶型汇总
    # ============================================================

    @bulk_wine_codes = {}
    @bottle_codes = []
    @bulk_wine = BulkWine.all.preload(:vendor).map do |bulk_wine|
      [bulk_wine.id, bulk_wine.desc]
    end.to_h

    OrderProduction.preload(:bulk_wine).map do |order_production|
      next if @bulk_wine[order_production.bulk_wine_id].blank?
      @bulk_wine_codes[order_production.bulk_wine_id] = @bulk_wine[order_production.bulk_wine_id]
      next if order_production.bottle_code == '无'
      @bottle_codes << order_production.bottle_code
    end
    @bottle_codes.compact!.uniq! rescue nil

    @bottle_info = {}
    @bulk_wine_info = {}

    #循环订单附表
    @order_productions.preload(:order).map do |o_product|
      bottle_code = o_product.bottle_code
      bulk_wine_code = @bulk_wine[o_product.bulk_wine_id] rescue nil
      next if bulk_wine_code.blank?
      next if bottle_code == '无'

      # 产品汇总
      @bulk_wine_info[bulk_wine_code] ||= {:selling => 0, :submited => 0, :ordered => 0}

      if o_product.order.status == 0
        selling = o_product.total_volume / 1000
        @bulk_wine_info[bulk_wine_code][:selling] += selling
      elsif o_product.order.status == 1
        submited = o_product.total_volume / 1000
        @bulk_wine_info[bulk_wine_code][:submited] += submited
      elsif o_product.order.status.in?([12,2,3,4])
        ordered = o_product.total_volume / 1000
        @bulk_wine_info[bulk_wine_code][:ordered] += ordered
      end

      # 瓶型汇总
      next if bottle_code.blank?
      next if params[:bulk_wine_code].present? && params[:bulk_wine_code] != bulk_wine_code

      @bottle_info[bottle_code] ||= {:selling => 0, :submited => 0, :ordered => 0}
      if o_product.order.status == 0
        @bottle_info[bottle_code][:selling] += o_product.production_num
      elsif o_product.order.status == 1
        @bottle_info[bottle_code][:submited] += o_product.production_num
      elsif o_product.order.status != 1 && o_product.order.status != 7
        @bottle_info[bottle_code][:ordered] += o_product.production_num
      end
    end
  end

  def show
    order_ids = Order.where(split_from: @order.id).where('status < 50 and status != 7').ids
    order_ids += [@order.id]
    @order_productions = OrderProduction.where(order_id: order_ids)
  end

  def create
    user = User.find(params[:user_id]) rescue nil
    if user.blank?
      flash[:error] = '请先选择客户！'
      return redirect_to "/admin/orders_new?sort=#{params[:sort]}"
    end

    way = Order::DELIVERY_WAY[params[:delivery_way_id].to_i]
    params[:delivery_way] = way
    params[:seller_id] = @admin_session.id
    params[:status] = 0
    params[:order] = params
    @order = Order.create params.require(:order).permit(*Order.attrs)
    @order.update :order_number => @order.id + 561

    redirect_to "/admin/orders/#{@order.id}/edit?step=1"
  end

  def edit
    if @order.blank?
      flash[:error] = '不存在该订单'
      return redirect_to request.referer
    end

    if @order.status.in?([5, 7, 8, 10, 19])
      flash[:error] = '不能编辑该订单'
      return redirect_to '/admin/orders'
    end

    if @order.status == 0 && @order.seller_id != @admin_session.id
      flash[:error] = '没有权限编辑该订单'
      return redirect_to '/admin/orders'
    end

    # 禁止销售编辑下单之后的订单
    # if @admin_session.role == 2 && @order.status > 0
    #   flash[:error] = '没有权限编辑该订单'
    #   return redirect_to '/admin/orders'
    # end

    # 清理空数据order_productions
    if @order.status == 0
      @order.clear_nil_production
    end

    # 管理员修改权限
    if [1, 12, 2, 3, 1+50, 12+50].include?(@order.status) && @admin_session.role.in?([0,1,2,5])
      # 1, 12 - 可修改包材, 2,3 - 只能修改贸易信息

      # 状态：12 - 只有管理理员可以修改包材信息，以及订货数量。
      # 修改完成后的订单，需要通过邮件系统，发送（订单汇总表，同一个订单号码-V2）
      if [1, 2].include?(@order.status)
        Order.where(:order_number => @order.order_number)
        .where('status > 50')
        .where.not(id: @order.id).delete_all
        # 这里copy的订单，会生成一个临时状态为9的订单，最终保存的时候，再把之前的订单替换掉
        @order = @order.copy
        @order.status -= 50
      end

      if [1+50, 2+50].include?(@order.status)
        @order.status -= 50
      end
    end

    @controller = :Quotation if @order.status == 0
    @form_action = "/admin/orders/#{@order.id}"
    @form_method = :put
    @title = "编辑#{Order::SORT[@order.sort]}"
    render "/admin/orders_new/index"
  end

  def update
    params[:order] = params
    @order.update params.require(:order).permit(*Order.attrs)
    @order.update delivery_way: Order::DELIVERY_WAY[@order.delivery_way_id]

    params[:step] = 1 if params[:step].blank?
    params[:step] = params[:step].to_i + 1

    if params[:step] == 5
      # 完成提交的时候，更换订单
      if @order.status == 0
        # 如果是直接下单，不走购物车。
        if @order.auto_confirm == 1
          # 检查产品库存是不是够
          if !@order.check_stock
            flash[:error] = '库存不足，暂时无法下单！'
            return redirect_to "/admin/orders/#{@order.id}/edit?step=2"
          end

          @order.update :status => 1, :date_submit => Time.now
          BulkWineStock.update_stock(@order)
          GmailCpts.order_new(@order) rescue nil
        end
      end

      # ======================
      # 新版本：2019-04-16
      # 状态0的订单是报价单，不考虑库存
      # 更新的时候，直接保存即可
      # ======================

      if @order.status_tmp?
        order = Order.where(:order_number => @order.order_number, :status => @order.status - 50).first
        args = @order.attrs.except(:id, :created_at)
        args[:version] = order.version + 1
        args[:status] = order.status
        order.update args

        bulk_wine_ids = order.order_productions.pluck(:bulk_wine_id)

        order.order_productions.delete_all
        @order.order_productions.update_all :order_id => order.id
        @order.destroy
        # 删除前订单的库存占用
        BulkWineStock.update_stock(nil, bulk_wine_ids)

        Order.find(order.id).update_total_price
        GmailCpts.order_updated(Order.find(order.id), @admin_session) rescue nil
        @order = order
      end

      if @order.status.in?([1, 12, 2, 3, 4])
        # 更新订单的库存占用
        BulkWineStock.update_stock Order.find(@order.id)
      end

      if @order.status == 0
        return redirect_to session[:list_url]
      end
      return redirect_to "/admin/orders?status=#{@order.status}"
    end

    respond_to do |format|
      format.html { redirect_to "/admin/orders_new?order_id=#{@order.id}&step=#{params[:step]}" }
      format.json { render :json => {:code => 1} }
    end
  end

  # def cancel_produce
  #   if @order.blank? || @order.status != 3
  #     return redirect_to request.referer
  #   end

  #   if OrderProductionDelivery.where(order_id: @order.id).present?
  #     flash[:error] = '已添加到发货预约集装箱中，无法撤销此订单'
  #     return redirect_to request.referer
  #   end

  #   @order.update :status => 2, :need_delivery => 1
  #   OrderProductionTransition.where(order_id: @order.id).delete_all

  #   redirect_to request.referer
  # end

  def destroy
    if @order.blank?
      flash[:error] = '不存在该订单'
      return redirect_to request.referer
    end

    # 非销售, 管理员, 生产主管 都没有权限
    if !@admin_session.role.in?([0,1,2,5])
      flash[:error] = '您没有权限删除该订单！'
      return redirect_to request.referer
    end

    # 销售
    if @admin_session.id == @order.seller_id
      if @order.status > 1
        flash[:error] = '您没有权限删除该订单！'
        return redirect_to request.referer
      end
    else
      if @order.status == 0 || @order.status > 2
        flash[:error] = '您没有权限删除该订单！'
        return redirect_to request.referer
      end
    end

    @order.update :status => 7
    BulkWineStock.update_stock(@order)

    #订单记录表添加撤销订单记录
    args = {
      :order_id => @order.id,
      :operate_id => @admin_session.id,
      :operate_rank => 1, # 1 - 管理员 2 - 客户
      :operate_type => 2, # 撤销订单订单
    }
    order_record = OrderRecord.create args

    flash[:success] = '撤销成功'
    redirect_to request.referer
  end

  def restore
    if @order.blank? || @order.status != 7
      flash[:error] = '不存在该订单！'
      return redirect_to request.referer
    end

    # 恢复之前，考虑库存还够不够
    out_of_stock = []
    @order.order_productions.map do |order_production|
      bulk_wine = order_production.bulk_wine
      if bulk_wine.stock.blank? || order_production.production_num > bulk_wine.stock.stock
        out_of_stock << bulk_wine.desc
      end
    end

    if out_of_stock.present?
      flash[:error] = "【#{out_of_stock.join('，')}】超过库存，无法恢复此订单到购物车！"
      return redirect_to request.referer
    end

    if @order.status == 7 && can?(:restore, :Order)
      @order.update :status => 0, :date_submit => nil
      flash[:success] = '购物车订单恢复成功！'

      BulkWineStock.update_stock(@order)

      args = {
        :order_id => @order.id,
        :operate_id => @admin_session.id,
        :operate_rank => 1,
        :operate_type => 6,
      }
      OrderRecord.create args
    end
    redirect_to request.referer
  end

  # 提交预订单
  def submit
    if @order.blank? || @order.status > 0
      flash[:error] = '不存在该订单！'
      return redirect_to request.referer
    end

    if !@order.check_stock
      flash[:error] = '库存不足，暂时无法下单！'
      return redirect_to request.referer
    end

    if @order.order_productions.pluck(:too_little).include?(1)
      flash[:error] = '未到起订量，暂时无法下单！'
      return redirect_to request.referer
    end

    args = {
      :status => 1,
      :date_submit => Time.now
    }
    @order.update args
    # 订单记录表添加提交订单记录
    args = {
      :order_id => @order.id,
      :operate_id => @admin_session.id,
      :operate_rank => 1, #1-管理员 2-客户
      :operate_type => 1, #提交订单
    }
    OrderRecord.create args
    BulkWineStock.update_stock(@order)
    GmailCpts.order_new(@order) rescue nil

    flash[:success] = '预订单提交成功！'
    redirect_to request.referer
  end


  def cancel_submit
    if @order.blank? || @order.status != 1
      return redirect_to request.referer
    end

    @order.update :status => 0
    BulkWineStock.update_stock(@order)
    redirect_to request.referer
  end


  # 确认下单
  # 2019-04-29 从在谈订单确认下单 更改为 报价单确认成财务复核，如果量不够则成为预订单
  def confirm
    if @order.blank?
      flash[:error] = '不存在该订单！'
      return redirect_to '/admin/quotations'
    end

    args = {
      :status => 2 ,
      :date_confirm => Time.now
    }
    @order.update args

    # 订单记录表添加提交订单记录
    args = {
      :order_id => @order.id,
      :operate_id => @admin_session.id,
      :operate_rank => 1, #1-管理员 2-客户
      :operate_type => 4, #确认订单
    }
    OrderRecord.create args
    flash[:success] = '确认下单成功！'
    redirect_to request.referer
  end

  # 复核完成
  def recheck
    if @order.blank?
      flash[:error] = '不存在该订单'
      return redirect_to '/admin/orders'
    end

    if @order.status.to_i == 2
      @order.update :status => 3, :date_recheck => Time.now

      # 订单记录表添加提交订单记录
      args = {
        :order_id => @order.id,
        :operate_id => @admin_session.id,
        :operate_rank => 1,
        :operate_type => 7,
      }
      OrderRecord.create args
      @order.to_transitions
    end

    flash[:success] = '订单复核完成！'
    redirect_to request.referer
  end

  def cancel_recheck
    if @order.blank? || @order.status != 3
      return redirect_to request.referer
    end

    if @order.order_productions.pluck(:produced).sum > 0
      flash[:error] = '已安排灌装，不能撤回！'
      return redirect_to request.referer
    end

    @order.update :status => 2
    # 删除OrderProductionTransition
    @order.order_production_transitions.map{|t| t.delete}
    @order.order_production_deliveries.map{|t| t.delete}

    redirect_to request.referer
  end


  # 备货完成/生产完成
  def produced
    @order_production = OrderProduction.find(params[:id])
    if @order_production.blank?
      flash[:error] = '不存在该单品'
      return redirect_to request.referer
    end

    if ![0,1,2,3].include?(params[:produced].to_i)
      flash[:error] = '参数错误'
      return redirect_to request.referer
    end

    @order_production.update produced: params[:produced].to_i
    @order = @order_production.order
    if @order.order_productions.pluck(:produced).sum > 0
      @order.update status: 4
    else
      @order.update status: 3
    end

    args = {
      :order_id => @order.id,
      :operate_id => @admin_session.id,
      :operate_rank => 1,
      :operate_type => 5,
      :remark => "order_production=#{@order_production.id}, produced=#{params[:produced]}",
    }
    OrderRecord.create args
    redirect_to request.referer
  end

  def pay
    @order_production = OrderProduction.find(params[:id])
    if @order_production.blank?
      flash[:error] = '不存在该单品'
      return redirect_to request.referer
    end

    if @order_production.shipped.zero?
      flash[:error] = '参数错误'
      return redirect_to request.referer
    end

    @order_production.update paid: 1

    args = {
      :order_id => @order_production.order_id,
      :operate_id => @admin_session.id,
      :operate_rank => 1,
      :operate_type => 10,
      :remark => "order_production=#{@order_production.id}",
    }
    OrderRecord.create args
    redirect_to request.referer
  end

  def print
    render :layout => 'mail'
  end

  # 导出EXCEL
  def export
    # 待补充库存
    order_ids = Order.where(:status => 0).ids
    quotations = {}
    OrderProduction.where(order_id: order_ids)
    .map do |order_production|
      quotations[order_production.bulk_wine_id] ||= 0
      quotations[order_production.bulk_wine_id] += order_production.real_num
    end

    bulk_wine_ids = OrderProduction.where(order_id: Order.where(:status => 0).ids).pluck(:bulk_wine_id).uniq
    # @out_stocks = {}
    @out_stocks = {}
    BulkWineStock.where(bulk_wine_id: quotations.keys).map do |stock|
      if stock.stock < quotations[stock.bulk_wine_id]
        @out_stocks[stock.bulk_wine_id] = {
          bulk_wine: stock.bulk_wine,
          number: quotations[stock.bulk_wine_id] - stock.stock
        }
      end
    end

    # conditions, values = conditions_values
    # conditions << 'status not in (7, 8, 9, 10)'

    # orders = Order.where(conditions.join(' and '), *values)
    # order_ids = orders.ids
    # user_ids = orders.pluck(:user_id).uniq
    # admin_ids = orders.pluck(:seller_id).uniq

    # users = User.where(id: user_ids).map { |user| [user.id, user] }.to_h
    # sellers = Admin.where(id: admin_ids).map { |admin| [admin.id, admin] }.to_h

    # order_productions = OrderProduction.where(:order_id => order_ids).preload(:order, :bulk_wine, :bottle, :cork, :cap, :carton)
    datas = [
      [
        "订单编号","下单日期","销售人员","客户名称",
        "产品类型","产品编码","产品描述","数量（瓶数）","包装类型","箱数合计",
        "产品酒标名称","瓶型","酒瓶要求","木塞","木塞印刷","胶帽","胶帽类型","螺旋盖","螺旋盖类型","分隔板","纸箱",
        "订单状态", "生产状态", "发货状态", "尾款状态",
        "预订单提交时间","确认下单时间","财务复核时间","更新时间",
        "币种","来源","备注"
      ],
    ]
    @order_productions.order('order_id asc').map do |o_product|
      data_attr = []
      if o_product.order.present? && o_product.bulk_wine.present?
        order = o_product.order

        data_attr << order.order_number
        data_attr << time_human(order.created_at)

        data_attr << (o_product.seller.true_name rescue '')
        data_attr << (o_product.user.name rescue '')

        data_attr << o_product.bulk_wine.sort_show
        data_attr << o_product.bulk_wine.code
        data_attr << o_product.bulk_wine.export_name

        data_attr << o_product.production_num.to_i
        data_attr << o_product.package
        data_attr << o_product.boxes
        data_attr << o_product.brand

        data_attr << o_product.bottle_code
        data_attr << Bottle::CUSTOMIZE[o_product.bottle_customize]

        data_attr << o_product.cork_desc.to_s
        data_attr << o_product.cork_print_show

        next if o_product.bottle_code.blank?
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

        if order.status == 4
          data_attr << o_product.produced_show
        elsif order.status == 5
          data_attr << o_product.paid_show
        else
          data_attr << order.status_show
        end

        data_attr << o_product.produced_show
        data_attr << o_product.shipped_show
        data_attr << o_product.paid_show

        data_attr << time_human(order.date_submit)
        data_attr << time_human(order.date_confirm)
        data_attr << time_human(order.date_recheck)
        data_attr << time_human(order.updated_at)

        currency = (Order::CURRENCY[order.currency] rescue '')
        data_attr << currency

        data_attr << providers.join('; ')
        data_attr << o_product.remark.to_s
      end
      datas << data_attr
    end

    sname = "TWS-Order-" + Time.now.strftime('%Y%m%d%H%M')
    write_xlsx(datas,sname,:string)
    send_file "#{Const::UPLOAD_EXCEL}/#{sname}.xlsx"
  end

  def order_produce_type
    op = OrderProduction.find(params[:order_product_id])
    if op.blank?
      return render :json => {:error => true}
    end

    op.update :produce_type => params[:produce_type].to_i
    render :json => {:success => true}
  end

  private
  def find_model
    @order = Order.find(params[:id]) rescue nil if params[:id]
  end


end
