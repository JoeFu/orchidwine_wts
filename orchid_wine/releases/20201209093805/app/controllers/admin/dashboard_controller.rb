class Admin::DashboardController < Admin::ApplicationController

  def index
    @date_start = Time.now.beginning_of_month.to_date
    if params[:date_start].present?
      @date_start = params[:date_start]
    end

    @date_end = Time.now.end_of_month.to_date
    if params[:date_end].present?
      @date_end = params[:date_end]
    end

    if @admin_session.role.in?([0, 1, 4])
      @sort = 1
      if params[:sort].present?
        @sort = params[:sort].to_i
      end
      @sales_statistics = Order.sales_statistics(@date_start, @date_end, @sort)
    end

    order_ids = Order.where(:status => 1).ids
    @merges = OrderProduction.where(order_id: order_ids)

    order_ids = Order.where(:status => 0).ids
    quotations = {}
    OrderProduction.where(order_id: order_ids)
    .map do |order_production|
      quotations[order_production.bulk_wine_id] ||= 0
      quotations[order_production.bulk_wine_id] += order_production.real_num
    end

    @out_stocks = {}
    BulkWineStock.where(bulk_wine_id: quotations.keys).map do |stock|
      if stock.stock < quotations[stock.bulk_wine_id]
        @out_stocks[stock.bulk_wine_id] = {
          bulk_wine: stock.bulk_wine,
          number: quotations[stock.bulk_wine_id] - stock.stock
        }
      end
    end

    if @admin_session.role == 2
      @oem_quotaiton_count = Order.where(:status => 0, :seller_id => @admin_session.id, :sort => 1).count
      @bottling_quotaiton_count = Order.where(:status => 0, :seller_id => @admin_session.id, :sort => 2).count
      @user_count = User.where(:admin_id => @admin_session.id).count
      @import_company_count = ImportCompany.count
    end
  end

  def export
    @date_start = Time.now.beginning_of_month.to_date
    if params[:date_start].present?
      @date_start = params[:date_start]
    end

    @date_end = Time.now.end_of_month.to_date
    if params[:date_end].present?
      @date_end = params[:date_end]
    end

    if @admin_session.role.in?([0, 1, 4])
      @sort = 1
      if params[:sort].present?
        @sort = params[:sort].to_i
      end
      @sales_statistics = Order.sales_statistics(@date_start, @date_end, @sort)
    end

    datas = [['销售人员','产品描述','Total','Unit price','Cost','Total sales value','Unit Margin']]

    @sales_statistics.map do |seller_name, productions|
      rowspan = productions.count
      i = 0
      num_count = 0
      total_fee = 0
      sunprodroduct = 0
      productions.map do |id, production|
        num_count += production[:total]
        total_fee += production[:total] * production[:price]
        margin = (production[:price] - production[:cost]) / production[:price]
        sunprodroduct += production[:total] * margin
        i += 1

        data = []
        data << seller_name
        data << production[:bulk_wine_name]
        data << production[:total]
        data << ('%.2f' % production[:price]).to_f
        data << production[:cost]
        data << ('%.2f' % (production[:total] * production[:price])).to_f
        data << '%.2f' % (margin * 100) + '%'
        datas << data
        if i == rowspan
          # data = [{:bg_color => 13}]
          data = []
          data << ''
          data << ''
          data << num_count
          data << ''
          data << ''
          data << ('%.2f' % total_fee).to_f
          data << '%.2f' % (sunprodroduct / num_count * 100) + '%'
          datas << data
        end
      end
    end

    sname = 'TWS-'
    if @sort == 1
      sname += 'Order-'
    else
      sname += 'Sales-'
    end

    # p datas
    sname += "Statistics-" + [@date_start.gsub('-', ''), @date_end.gsub('-', '')].join('-')
    write_xlsx(datas,sname,:string)
    send_file "#{Const::UPLOAD_EXCEL}/#{sname}.xlsx"
  end
end
