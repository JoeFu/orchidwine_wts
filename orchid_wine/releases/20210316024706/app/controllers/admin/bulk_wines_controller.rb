class Admin::BulkWinesController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions, values = [], []
    if params[:q].present?
      conditions << 'code like ?'
      values << "%#{params[:q]}%"
    end

    status = [0, 1]
    if params[:status].present?
      status = params[:status]
    end

    if params[:year].present?
      conditions << 'year = ?'
      values << params[:year]
    end

    if params[:vendor].present?
      vendors = BulkWineVendor.where('name like ?',  "%#{params[:vendor]}%")
      conditions << 'vendor_id in (?)'
      values << vendors.ids
    end

    @bulk_wines = BulkWine.where(conditions.join(' and '), *values)
    .where(:is_delete => 0, :status => status)
    .preload(:vendor)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      :vendor_id => '请选择供应商',
      :year => '请填写年份',
      :area_id_one => '请选择产地1',
      :area_id_two => '请选择产地2',
      :variety_id_one => '请选择品种1',
      :variety_id_two => '请选择品种2',
      :variety_id_three => '请选择品种3',
      :alcoholic_strength => '请填写酒精度',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/bulk_wines/new'
      end
    end

    variety_id_one = params[:variety_id_one].to_i
    variety_id_two = params[:variety_id_two].to_i
    variety_id_three = params[:variety_id_three].to_i

    if (variety_id_one == variety_id_three && variety_id_one != variety_id_two) ||
        (variety_id_one == variety_id_two && variety_id_two != variety_id_three)
      flash[:error] = '品种搭配不正确，请修改！'
      return render '/admin/bulk_wines/new'
    end

    # vendor_code = BulkWineVendor.find(params[:vendor_id]).vendor_code rescue nil
    vendor = BulkWineVendor.find(params[:vendor_id])
    if vendor.blank?
      flash[:error] = '请选择供应商'
      return render '/admin/bulk_wines/new'
    end
    params[:vendor_name] = vendor.name
    params[:batch] = params[:batch][0] rescue '1'
    params[:alcoholic_strength] = float_int(params[:alcoholic_strength])

    params[:bulk_wine] = params
    # 验证重复
    bk = BulkWine.new params.require(:bulk_wine).permit(*BulkWine.attrs)
    _bk = BulkWine.where(code: bk.init_code, is_delete: 0).first
    if _bk.present?
      flash[:error] = '已有重复的产品，请修改参数！'
      return render '/admin/bulk_wines/new'
    end

    bulk_wine = BulkWine.create params.require(:bulk_wine).permit(*BulkWine.attrs)
    bulk_wine.update :desc => bulk_wine.init_desc, :code => bulk_wine.init_code
    flash[:success] = '产品注册成功！'
    redirect_to '/admin/bulk_wines'
  end

  def update
    {
      :vendor_id => '请选择供应商',
      :year => '请填写年份',
      :area_id_one => '请选择产地1',
      :area_id_two => '请选择产地2',
      :variety_id_one => '请选择品种1',
      :variety_id_two => '请选择品种2',
      :variety_id_three => '请选择品种3',
      :alcoholic_strength => '请填写酒精度',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return redirect_to "/admin/bulk_wines/#{@bulk_wine.id}/edit"
      end
    end

    variety_id_one = params[:variety_id_one].to_i
    variety_id_two = params[:variety_id_two].to_i
    variety_id_three = params[:variety_id_three].to_i

    if (variety_id_one == variety_id_three && variety_id_one != variety_id_two) ||
        (variety_id_one == variety_id_two && variety_id_two != variety_id_three)
      flash[:error] = '品种搭配不正确，请修改！'
      return redirect_to "/admin/bulk_wines/#{@bulk_wine.id}/edit"
    end

    vendor = BulkWineVendor.find(params[:vendor_id])
    if vendor.blank?
      flash[:error] = '请选择供应商'
      return redirect_to "/admin/bulk_wines/#{@bulk_wine.id}/edit"
    end
    params[:vendor_name] = vendor.name
    params[:batch] = params[:batch][0] rescue '1'
    params[:alcoholic_strength] = (params[:alcoholic_strength].to_f * 100).to_i
    params[:bulk_wine] = params

    # 验证重复
    bk = BulkWine.new params.require(:bulk_wine).permit(*BulkWine.attrs)
    _bk = BulkWine.where(code: bk.init_code, is_delete: 0).where.not(id: @bulk_wine.id).first
    if _bk.present?
      flash[:error] = '已有重复的产品，请修改参数！'
      return redirect_to "/admin/bulk_wines/#{@bulk_wine.id}/edit"
    end

    @bulk_wine.update params.require(:bulk_wine).permit(*BulkWine.attrs)
    @bulk_wine.update :desc => @bulk_wine.init_desc, :code => @bulk_wine.init_code

    args = {
      bulk_wine_code: @bulk_wine.code,
      bulk_wine_desc: @bulk_wine.desc
    }
    OrderProduction.where(bulk_wine_id: @bulk_wine.id).update_all args

    flash[:success] = '产品编辑成功！'
    redirect_to session[:list_url]
  end

  def status
    if @bulk_wine.status.zero?
      bw = BulkWine.where(code:@bulk_wine.code, status: 1, is_delete: 0).first
      if bw.present?
        flash[:error] = '操作失败，有重复的产品已上架！'
        return redirect_to session[:list_url]
      end
    end

    @bulk_wine.update :status => @bulk_wine.status ^ 1
    flash[:success] = "产品#{@bulk_wine.status.zero? ? '下架' : '上架'}操作成功！"

    # 上架的时候判断一下有没有产品 bulk_wine
    if @bulk_wine.status == 1 && @bulk_wine.stock.blank?
      BulkWineStock.create :bulk_wine_id => @bulk_wine.id, :id => @bulk_wine.id
    end

    redirect_to session[:list_url]
  end

  def show
    order_ids = OrderProduction.where(bulk_wine_id: @bulk_wine.id).pluck(:order_id)
    conditions, values = [], []
    conditions << 'id in (?)'
    values << order_ids

    if params[:status].present?
      conditions << 'status = ?'
      values << params[:status].to_i
    else
      conditions << 'status in (0,1,12,2,3,4)'
    end

    @orders = Order.where(conditions.join(' and '), *values)
    .preload(:user, :seller, :order_productions)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def destroy
    @bulk_wine.update :is_delete => 1
    flash[:success] = '产品删除成功！'
    redirect_to session[:list_url]
  end

  def get_json
    options = []

    conditions, values = [], []
    if params[:sort_id].present?
      conditions << 'sort_id = ?'
      values << params[:sort_id]
    end

    if params[:year].present?
      conditions << 'year = ?'
      values << params[:year]
    end
    conditions << 'is_delete = 0'
    conditions << 'status = 1'

    bulk_wines = BulkWine.where(conditions.join(' and '), *values)
    # bulk_wines = BulkWine.where(:sort_id => params[:sort_id], :year => params[:year], :is_delete => 0, :status => 1)
    if (variety_id = params[:variety_id].to_i) > 0
      bulk_wines = bulk_wines.where('variety_id_one = ? or variety_id_two = ?',
                                    params[:variety_id],
                                    params[:variety_id])
    end
    bulk_wines.order('year asc, vendor_id asc, variety_id_one asc')
    .map do |bulk_wine|
      html = <<-HTML
      <option value="%s" data-price="%s">%s</option>
      HTML

      options << html % [bulk_wine.code, bulk_wine.price, bulk_wine.desc]
    end

    if options.blank?
      options << "<option value=''>暂无产品可选</option>"
    end

    render :json => {code: 1, data: options }
  end


  private
  def find_model
    @bulk_wine = BulkWine.find(params[:id]) if params[:id]
  end
end
