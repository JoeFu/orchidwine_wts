class Admin::DeliveriesController < Admin::ApplicationController
  before_action :find_model, :except => [:no_need]
  before_action :delivery_count, :only => [:transition, :index]
  before_action :order_production_deliveries_group, :only => [:manager, :send, :send_put]

  def transition
    transition_orders
  end

  def no_need
    order = Order.find(params[:id])
    if order.present?
      order.update :need_delivery => 0
      order.order_productions.update_all :shipped => 1
      order.order_production_transitions.map(&:destroy)
      if order.status == 3
        order.update :status => 4
      end
    end
    redirect_to '/admin/deliveries/transition'
  end

  def index
    conditions, values = conditions_values
    @deliveries = Delivery.where(conditions.join(' and '), *values)
    .preload(:order_productions)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def new
  end

  def create
    {
      :export_company_name => '请填写出口方公司名称！',
      :export_company_contacts => '请填写出口方联系人！',
      :export_company_telephone => '请填写出口方电话！',
      :export_company_email => '请填写出口方电子邮箱！',
      :export_company_abn => '请填写出口方公司ABN！',
      :export_company_address => '请填写出口方地址！',
      :import_company_name => '请填写进口接货方公司名称！',
      :import_company_contacts => '请填写进口接货方联系人！',
      :import_company_telephone => '请填写进口接货方电话！',
      :import_company_email => '请填写进口接货方电子邮箱！',
      :import_company_uscc => '请填写进口接货方社会统一信用代码！',
      :import_company_address => '请填写进口接货方地址！',
      :booking_number => '预约号必须填写！',
      :shipping_company => '请填写货代名称！',
      :shipping_company_telephone => '请填写联系电话！',
      :port_of_loading => '请填写出发港！',
      :port_of_discharge => '请填写目的港！',
    }.map do |k, v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/deliveries/new'
      end
    end

    import_company = ImportCompany.where(:name => params[:import_company_name]).first
    if import_company.blank?
      args = {
        :name => params[:import_company_name],
        :contacts => params[:import_company_contacts],
        :telephone => params[:import_company_telephone],
        :email => params[:import_company_email],
        :uscc => params[:import_company_uscc],
        :address => params[:import_company_address],
      }
      ImportCompany.create args
    end

    params[:cutoff_date] = [params[:cutoff_date], params[:cutoff_datetime]].join(' ')
    params[:delivery] = params

    @delivery = Delivery.create params.require(:delivery).permit(*Delivery.attrs)
    flash[:success] = '集装箱预约成功！'
    redirect_to '/admin/deliveries?status=1'
  end

  def edit
  end

  def update
    {
      :export_company_name => '请填写出口方公司名称！',
      :export_company_contacts => '请填写出口方联系人！',
      :export_company_telephone => '请填写出口方电话！',
      :export_company_email => '请填写出口方电子邮箱！',
      :export_company_abn => '请填写出口方公司ABN！',
      :export_company_address => '请填写出口方地址！',
      :import_company_name => '请填写进口接货方公司名称！',
      :import_company_contacts => '请填写进口接货方联系人！',
      :import_company_telephone => '请填写进口接货方电话！',
      :import_company_email => '请填写进口接货方电子邮箱！',
      :import_company_uscc => '请填写进口接货方社会统一信用代码！',
      :import_company_address => '请填写进口接货方地址！',
      :booking_number => '预约号必须填写！',
      :shipping_company => '请填写货代名称！',
      :shipping_company_telephone => '请填写联系电话！',
      :port_of_loading => '请填写出发港！',
      :port_of_discharge => '请填写目的港！',
    }.map do |k, v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/deliveries/edit'
      end
    end

    import_company = ImportCompany.where(:name => params[:import_company_name]).first
    if import_company.blank?
      args = {
        :name => params[:import_company_name],
        :contacts => params[:import_company_contacts],
        :telephone => params[:import_company_telephone],
        :email => params[:import_company_email],
        :uscc => params[:import_company_uscc],
        :address => params[:import_company_address],
      }
      ImportCompany.create args
    end

    params[:cutoff_date] = [params[:cutoff_date], params[:cutoff_datetime]].join(' ')
    params[:delivery] = params
    @delivery.update params.require(:delivery).permit(*Delivery.attrs)
    redirect_to '/admin/deliveries?status=1'
  end

  def manager
    if params[:container_id].present?
      transition_orders
      @container = Container.where(id: params[:container_id], delivery_id: @delivery.id).first
      if @container.blank?
        redirect_to "/admin/deliveries/#{@delivery.id}/manager"
      end

      select_transitions
    end
  end

  def container_new
    @container = Container.create :delivery_id => @delivery.id
    redirect_to "/admin/deliveries/#{@delivery.id}/manager?container_id=#{@container.id}"
  end

  def container_selected
    @container = Container.find(params[:container_id])
    if @container.blank? || @container.delivery_id != @delivery.id
      return redirect_to "/admin/deliveries/#{@delivery.id}/manager"
    end

    @container.update :size => params[:size].to_i

    splits = @delivery.order_production_deliveries.where(container_id: @container.id).pluck(:order_id, :is_split).to_h
    @delivery.to_transition(@container.id)
    if params[:order_production_ids].class == Array
      params[:order_production_ids].map do |order_production_id|
        order_production_transition = OrderProductionTransition.where(order_production_id: order_production_id).first
        num = params["transition-num-#{order_production_id}"].to_i

        next if num.zero?
        next if order_production_transition.blank?

        if num > order_production_transition.num
          num = order_production_transition.num
        end

        is_split = splits[order_production_transition.order_id].to_i

        args = {
          delivery_id: @delivery.id,
          order_id: order_production_transition.order_id,
          order_number: order_production_transition.order_number,
          user_id: order_production_transition.user_id,
          order_production_id: order_production_id,
          num: num,
          is_split: is_split,
          container_id: @container.id,
        }

        OrderProductionDelivery.create args

        if num == order_production_transition.num
          order_production_transition.delete
        else
          order_production_transition.num -= num
          order_production_transition.save
        end
      end
    end
    @delivery.update_split
    @delivery.update_total_bottle_num
    redirect_to "/admin/deliveries/#{@delivery.id}/manager"
  end

  def send_put
    if @delivery.status != 1
      flash[:error] = '参数异常！'
      return redirect_to session[:list_url]
    end

    @delivery.containers.map do |container|
      if params["container_#{container.id}_number"].blank?
        flash[:error] = "请填写 集装箱 NO-#{container.id} 号！"
        return render '/admin/deliveries/send'
      else
        container.update :container_number => params["container_#{container.id}_number"]
      end
    end

    {
      # :export_company_name => '请填写出口方公司名称！',
      # :export_company_contacts => '请填写出口方联系人！',
      # :export_company_telephone => '请填写出口方电话！',
      # :export_company_email => '请填写出口方电子邮箱！',
      # :export_company_address => '请填写出口方地址！',
      # :import_company_name => '请填写进口接货方公司名称！',
      # :import_company_contacts => '请填写进口接货方联系人！',
      # :import_company_telephone => '请填写进口接货方电话！',
      # :import_company_email => '请填写进口接货方电子邮箱！',
      # :import_company_address => '请填写进口接货方地址！',
      :wea_number => '请填写WEA出口许可证号！',
      # :container_number => '请填写集装箱号！',
      :packing_list => '请上传发货单！',
    }.map do |k, v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/deliveries/send'
      end
    end

    params[:status] = 2
    params[:order] = params
    @delivery.update params.require(:order).permit(*Delivery.attrs)
    @delivery.update_order_status

    flash[:success] = '集装箱发货，操作成功！'
    redirect_to '/admin/deliveries?status=2'
  end

  def status
    if @delivery.status + 1 == params[:status].to_i
      @delivery.update :status => @delivery.status + 1
    end

    flash[:success] = '订单状态更新成功！'
    redirect_to "/admin/deliveries?status=#{@delivery.status}"
  end

  def destroy
    if @delivery.status == 1
      @delivery.to_transition
      @delivery.destroy
      flash[:success] = '预约仓位删除成功！'
    else
      flash[:error] = '预约仓位无法删除！'
    end
    redirect_to "/admin/deliveries"
  end

  def export
    rows = [
      [ '预约号', '货代名称', '货代联系电话', 'WEA许可证', '集装箱', '客户', '订单', '品牌', '产品', '包装方式', '数量', '隔热棉', '海运保险', '发往', '截关日期', '计划发货日期', '空集装箱取箱日', '状态', '操作日期', '出口方公司名称', '进口方公司名称']
    ]
    conditions, values = conditions_values
    # delivery_id = Delivery.where(conditions.join(' and '), *values).ids
    # order_productions = OrderProductionDelivery.where(:delivery_id => delivery_id)

    Delivery.where(conditions.join(' and '), *values)
    .preload(:order_production_deliveries, :order_productions, :user)
    .map do |delivery|
      delivery.order_production_deliveries.map do |order_production_delivery|
        data_ref = []

        data_ref << delivery.booking_number
        data_ref << delivery.shipping_company
        data_ref << delivery.shipping_company_telephone
        data_ref << (delivery.wea_number.present? ? delivery.wea_number : '待定')
        data_ref << order_production_delivery.show_container
        data_ref << order_production_delivery.user.name
        data_ref << order_production_delivery.order_number

        data_ref << order_production_delivery.order_production.brand
        data_ref << order_production_delivery.order_production.bulk_wine_desc
        data_ref << order_production_delivery.order_production.package

        data_ref << order_production_delivery.num

        data_ref << Delivery::COTTON_INSULATION[delivery.cotton_insulation]
        data_ref << (delivery.ocean_insurance == 1 ? '是' : '否')
        data_ref << delivery.port_of_discharge

        data_ref << delivery.cutoff_date.strftime('%Y-%m-%d %H:%M')
        data_ref << delivery.plan_date
        data_ref << delivery.get_container_date

        data_ref << delivery.status_show
        data_ref << delivery.updated_at.to_ymd

        data_ref << delivery.export_company_name
        # data_ref << delivery.export_company_contacts
        # data_ref << delivery.export_company_telephone
        # data_ref << delivery.export_company_email
        # data_ref << delivery.export_company_address
        data_ref << delivery.import_company_name
        # data_ref << delivery.import_company_contacts
        # data_ref << delivery.import_company_telephone
        # data_ref << delivery.import_company_email
        # data_ref << delivery.import_company_address

        rows << data_ref
      end
    end

    if params[:status].to_i == 1
      sname = "TWS-Booking-" + Time.now.strftime('%Y%m%d%H%M')
    elsif params[:status].to_i == 2
      sname = "TWS-shipping-" + Time.now.strftime('%Y%m%d%H%M')
    elsif params[:status].to_i == 3
      sname = "TWS-FIN-" + Time.now.strftime('%Y%m%d%H%M')
    end

    write_xlsx(rows,sname,:string)
    send_file "#{Const::UPLOAD_EXCEL}/#{sname}.xlsx"
  end

  private
  def find_model
    @delivery = Delivery.find(params[:id]) if params[:id]
  end

  def delivery_count
    @order_transition_count = OrderProductionTransition.all.pluck(:order_id).uniq.size
    @delivery_count = Delivery.counts
  end

  def conditions_values
    conditions, values =[], []
    if params[:status].present?
      conditions << 'status = ?'
      values << params[:status].to_i
    else
      conditions << 'status = 1'
      params[:status] = 1
    end

    if params[:shipping_company].present?
      conditions << 'shipping_company like ?'
      values << "%#{params[:shipping_company]}%"
    end

    if params[:user_name].present? || params[:order_number].present?
      cons, vals =[], []
      if params[:user_name].present?
        user_ids = User.where('name like ?', "%#{params[:user_name]}%").ids
        cons << 'user_id in (?)'
        vals << user_ids
      end

      if params[:order_number].present?
        cons << 'order_number = ?'
        vals << params[:order_number]
      end

      delivery_id = OrderProductionDelivery.where(cons.join(' and '), *vals).pluck(:delivery_id)
      conditions << 'id in (?)'
      values << delivery_id
    end

    [conditions, values]
  end

  def transition_orders
    conditions, values = [],[]
    if params[:user_name].present?
      user_ids = User.where('name like ?', "%#{params[:user_name]}%").ids
      conditions << 'user_id in (?)'
      values << user_ids
    end

    if params[:order_number].present?
      conditions << 'order_number = ?'
      values << params[:order_number]
    end
    conditions << 'id in (?)'
    values << OrderProductionTransition.pluck(:order_id).uniq

    @transition_orders = Order.where(conditions.join(' and '), *values).order('id desc')
    .preload(:order_production_transitions, :order_productions, :user)
  end

  def select_transitions
    @order_production_transitions = []
    other_order_production_ids = []

    @selected_order_production_ids = @delivery.order_production_deliveries.where(:container_id => @container.id).pluck(:order_production_id)

    other_order_production_ids = @selected_order_production_ids
    @transition_orders.map do |transition_order|
      transition_order.order_production_transitions.map do |order_production_transition|
        if order_production_transition.order_production_id.in?(@selected_order_production_ids)
          args = {
            :order_production_id => order_production_transition.order_production_id,
            :container_id => @container.id
          }
          order_production_delivery = @delivery.order_production_deliveries.where(args).first
          if order_production_delivery.present?
            order_production_transition.num += order_production_delivery.num
          end
        end

        @order_production_transitions << [transition_order.id, order_production_transition]
        other_order_production_ids -= [order_production_transition.order_production_id]
      end
    end

    @delivery.order_production_deliveries.where(order_production_id: other_order_production_ids).map do |order_production_delivery|
      args = {
        order_id: order_production_delivery.order_id,
        order_number: order_production_delivery.order_number,
        user_id: order_production_delivery.user_id,
        order_production_id: order_production_delivery.order_production_id,
        num: order_production_delivery.num,
      }
      @order_production_transitions << [args[:order_id], OrderProductionTransition.new(args)]
    end
  end

  def order_production_deliveries_group
    @order_production_deliveries = @delivery.order_production_deliveries.preload(:user).group_by{|opd| opd.container_id}
  end
end
