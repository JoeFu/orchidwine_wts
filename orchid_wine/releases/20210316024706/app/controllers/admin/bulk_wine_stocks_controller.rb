class Admin::BulkWineStocksController < Admin::ApplicationController
  before_action :find_model

  def index
    # conditions, values = [], []
    # if params[:q].present?
    #   conditions << 'code like ?'
    #   values << "%#{params[:q]}%"
    # end

    # if params[:desc].present?
    #   conditions << '`desc` like ?'
    #   values << "%#{params[:desc]}%"
    # end

    # # if params[:year].present?
    # #   conditions << 'year = ?'
    # #   values << params[:year]
    # # end

    # # if params[:vendor].present?
    # #   vendors = BulkWineVendor.where('name like ?',  "%#{params[:vendor]}%")
    # #   conditions << 'vendor_id in (?)'
    # #   values << vendors.ids
    # # end

    # conditions << 'is_delete = 0'
    # conditions << 'status = 1'

    # bulk_wine_ids = BulkWine.where(conditions.join(' and '), *values).ids
    # @bulk_wine_stocks = BulkWineStock.where(bulk_wine_id: bulk_wine_ids)
    # .preload(:bulk_wine, :cap, :bottle, :cork, :divider, :carton)
    # .limit(Const::ADMIN_PAGE_SIZE)
    # .order('id desc')
    # .page(params[:page])


    # order_ids = Order.where(status: 0).ids
    # @sellings = {}
    # OrderProduction.where(order_id: order_ids, bulk_wine_id: bulk_wine_ids)
    # .map do |order_production|
    #   @sellings[order_production.bulk_wine_id] ||= 0
    #   @sellings[order_production.bulk_wine_id] += order_production.real_num
    # end
  end

  def edit
    @bottle_type = @order_production.bottle_code.last rescue 'C'
  end

  def update
    {
      :price => '请填写销售单价',
      :cost => '请填写成本（含包材）',
      :min_number => '请填写最低购买量',
      :custom_number => '请填写自定义包材起量',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/bulk_wine_stocks/edit'
      end
    end

    bottle = Bottle.where(:bottle_code => params[:bottle_code]).first rescue nil
    if bottle.present?
      params[:bottle_id] = bottle.id
      params[:bottle_code] = bottle.bottle_code
    end

    args = {
      :price => params[:price].to_f,
      :cost => params[:cost].to_f
    }
    @bulk_wine_stock.bulk_wine.update args

    params[:bulk_wine_stock] = params
    @bulk_wine_stock.update params.require(:bulk_wine_stock).permit(*BulkWineStock.attrs)
    flash[:success] = '产品配置编辑成功！'
    redirect_to session[:list_url]
  end

  def show
    order_ids = OrderProduction.where(:bulk_wine_id => @bulk_wine_stock.bulk_wine_id).pluck(:order_id)
    @orders = Order.where(id: order_ids, status: 1)
    .preload(:user, :order_productions)
    .order('updated_at desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])


    order_ids = Order.where(id: order_ids, status: 0)
    @selling = 0
    OrderProduction.where(order_id: order_ids, bulk_wine_id: @bulk_wine_stock.bulk_wine_id)
    .map do |order_production|
      @selling += order_production.real_num
    end
  end

  def stock_add
    stock = params[:stock].to_i
    if stock.zero?
      flash[:error] = '参数错误！'
      return redirect_to request.referer
    end

    args = {
      :bulk_wine_id => @bulk_wine_stock.bulk_wine_id,
      :stock => params[:stock],
      :admin_id => @admin_session.id,
    }
    log = BulkWineStockLog.create args

    @bulk_wine_stock.stock = @bulk_wine_stock.stock + log.stock
    @bulk_wine_stock.total_stock = @bulk_wine_stock.total_stock + log.stock
    @bulk_wine_stock.save

    flash[:success] = '产品库存添加成功！'
    redirect_to session[:list_url]
  end

  def get_json
    bulk_wine = BulkWine.where(code: params[:bulk_wine_code], status: 1, is_delete: 0).first
    if bulk_wine.blank?
      return render :json => {code: 0, message: '参数错误！'}
    end

    render :json => {code: 1, data: bulk_wine.stock.info }
  end

  def export
    rows = [
      ['产品编码', '供应商', '年份', '产地', '品种', '酒精度', '标准售价', '成本', '总库存', '已销售', '可销售', '容量', '瓶型', '酒塞', '胶帽', '胶帽颜色', '分隔板', '包装方式', '纸箱', '更新日期']
    ]
    bulk_wine_ids = BulkWine.where(:is_delete => 0, :status => 1).ids
    BulkWineStock.where(bulk_wine_id: bulk_wine_ids).map do |bulk_wine_stock|
      bulk_wine = bulk_wine_stock.bulk_wine rescue nil
      next if bulk_wine.blank?
      row = []
      row << bulk_wine.code
      row << bulk_wine.vendor.code_name
      row << bulk_wine.year
      row << bulk_wine.areas_show.gsub('<br/>', ', ')
      row << bulk_wine.varieties_show.gsub('<br/>', ', ')
      row << bulk_wine.alcoholic_strength


      row << bulk_wine_stock.bulk_wine.price
      row << bulk_wine_stock.bulk_wine.cost

      row << bulk_wine_stock.total_stock
      row << bulk_wine_stock.sold_count
      row << bulk_wine_stock.can_sell_stock
      row << '750ml'

      if bulk_wine_stock.bottle.present?
        row << (bulk_wine_stock.bottle.bottle_code rescue nil)
        row << (bulk_wine_stock.bottle.bottle_code.last == 'B' ? nil : (bulk_wine_stock.cork.desc rescue nil))
      else
        row << nil
        row << nil
      end

      row << (bulk_wine_stock.cap.desc rescue '无')
      row << bulk_wine_stock.cap_color

      row << (bulk_wine_stock.divider.divider_type rescue '')
      row << (bulk_wine_stock.package rescue '')
      row << (bulk_wine_stock.carton.desc rescue '')

      row << time_human(bulk_wine_stock.updated_at)
      rows << row
    end
    file_name = "TWS-Wine-#{Time.now.strftime('%Y%m%d%H%M')}"
    write_xlsx(rows, file_name, :string)
    send_file "#{Const::UPLOAD_EXCEL}/#{file_name}.xlsx"
  end

  private
  def find_model
    @bulk_wine_stock = BulkWineStock.find(params[:id]) if params[:id]
  end
end
