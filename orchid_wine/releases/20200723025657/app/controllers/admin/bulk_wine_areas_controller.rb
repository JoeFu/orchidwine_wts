class Admin::BulkWineAreasController < Admin::ApplicationController
  before_action :find_model

  def index
    @bulk_wine_areas = BulkWineArea.where(:is_delete => 0).order('id desc')
    @used_area_ids = BulkWine.where(is_delete: 0).pluck(:area_id_one, :area_id_two).flatten.uniq
  end

  def create
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_areas/new'
      end
    end

    _area = BulkWineArea.where(:code => params[:code])
    if _area.present?
      flash[:error] = '产区编码不能重复，请修改'
      return render'/admin/bulk_wine_areas/new'
    end

    params[:bulk_wine_area] = params
    bulk_wine_area = BulkWineArea.create params.require(:bulk_wine_area).permit(*BulkWineArea.attrs)
    flash[:success] = '产区添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @bulk_wine_area.blank?
      flash[:error] = '不存在该产区'
      return redirect_to session[:list_url]
    end
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_areas/edit'
      end
    end

    _area = BulkWineArea.where(:code => params[:code]).where.not(id: @bulk_wine_area.id)
    if _area.present?
      flash[:error] = '产区编码不能重复，请修改'
      return redirect_to "/admin/bulk_wine_areas/#{@bulk_wine_area.id}/edit"
    end

    params[:bulk_wine_area] = params
    @bulk_wine_area.update params.require(:bulk_wine_area).permit(*BulkWineArea.attrs)
    flash[:success] = '产区编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    used = BulkWine.where(is_delete: 0).where('area_id_one = ? or area_id_two = ?', @bulk_wine_area.id, @bulk_wine_area.id).first
    if used.present?
      flash[:error] = '产区已使用，不能删除。'
      return redirect_to session[:list_url]
    end

    @bulk_wine_area.update :is_delete => 1
    flash[:success] = '产区删除成功！'
    redirect_to session[:list_url]
  end


  private
  def find_model
    @bulk_wine_area = BulkWineArea.find(params[:id]) if params[:id]
  end
end
