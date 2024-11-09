class Admin::BulkWineSortsController < Admin::ApplicationController
  before_action :find_model

  def index
    @bulk_wine_sorts = BulkWineSort.where(:is_delete => 0).order('id desc')
    @used_sort_ids = BulkWine.where(is_delete: 0).pluck(:sort_id).uniq
  end

  def create
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_sorts/new'
      end
    end

    if BulkWineSort.where(:code => params[:code]).present?
      flash[:error] = '商品类别编码不能重复，请修改'
      return render '/admin/bulk_wine_sorts/new'
    end

    params[:bulk_wine_sort] = params
    bulk_wine_sort = BulkWineSort.create params.require(:bulk_wine_sort).permit(*BulkWineSort.attrs)
    flash[:success] = '商品类别添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @bulk_wine_sort.blank?
      flash[:error] = '不存在该商品类别'
      return redirect_to session[:list_url]
    end
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_sorts/edit'
      end
    end

    _sort = BulkWineSort.where(:code => params[:code]).where.not(id: @bulk_wine_sort.id)
    if _sort.present?
      flash[:error] = '商品类别编码不能重复，请修改'
      return redirect_to "/admin/bulk_wine_sorts/#{@bulk_wine_sort.id}/edit"
    end

    params[:bulk_wine_sort] = params
    @bulk_wine_sort.update params.require(:bulk_wine_sort).permit(*BulkWineSort.attrs)
    flash[:success] = '商品类别编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    used = BulkWine.where(is_delete: 0).where('sort_id = ?', @bulk_wine_sort.id).first
    if used.present?
      flash[:error] = '商品类别已使用，不能删除。'
      return redirect_to session[:list_url]
    end

    @bulk_wine_sort.update :is_delete => 1
    flash[:success] = '商品类别删除成功！'
    redirect_to session[:list_url]
  end


  private
  def find_model
    @bulk_wine_sort = BulkWineSort.find(params[:id]) if params[:id]
  end
end
