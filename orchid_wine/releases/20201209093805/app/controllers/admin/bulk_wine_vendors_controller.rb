class Admin::BulkWineVendorsController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions, values = [], []
    if params[:q].present?
      conditions << 'name like ?'
      values << "%#{params[:q]}%"
    end
    conditions << 'is_delete = 0'

    @bulk_wine_vendors = BulkWineVendor.where(conditions.join(' and '), *values)
    .preload(:bulk_wines)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      :vendor_code => '请填写供应商编码',
      :name => '请填写供应商名称',
      :address => '请填写地址',
      :telphone => '请填写联系方式',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_vendors/new'
      end
    end
    if BulkWineVendor.where(:vendor_code => params[:vendor_code]).present?
      flash[:error] = '供应商编码不能重复，请修改'
      return render '/admin/bulk_wine_vendors/new'
    end
    # unless /^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/.match(params[:telphone].to_s)
    #   flash[:error] = '联系方式格式错误'
    #   return render "/admin/bulk_wine_vendors/index"
    # end
    params[:vendor] = params
    vendor = BulkWineVendor.create params.require(:vendor).permit(*BulkWineVendor.attrs)
    if vendor.present?
      flash[:success] = '新增成功'
      return redirect_to session[:list_url]
    end

    flash[:error] ='新增失败'
    render '/admin/bulk_wine_vendors/new'
  end

  def update
    {
      :vendor_code => '请填写供应商编码',
      :name => '请填写供应商名称',
      :address => '请填写地址',
      :telphone => '请填写联系方式',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_vendors/edit'
      end
    end

    _vendor = BulkWineVendor.where(:vendor_code => params[:vendor_code]).where.not(id: @vendor.id)
    if _vendor.present?
      flash[:error] = '供应商编码不能重复，请修改'
      return redirect_to "/admin/bulk_wine_vendors/#{@vendor.id}/edit"
    end

    params[:vendor] = params
    @vendor.update params.require(:vendor).permit(*BulkWineVendor.attrs)

    flash[:success] = '编辑成功'
    redirect_to session[:list_url]
  end

  def destroy
    @vendor.update :is_delete => 1
    flash[:success] = '供应商删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @vendor = BulkWineVendor.find(params[:id]) if params[:id]
  end
end
