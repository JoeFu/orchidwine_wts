class Admin::BulkWineVarietiesController < Admin::ApplicationController
  before_action :find_model

  def index
    @bulk_wine_varieties = BulkWineVariety.where(:is_delete => 0).order('id desc')
    @used_variety_ids = BulkWine.where(is_delete: 0).pluck(:variety_id_one, :variety_id_two, :variety_id_three).flatten.uniq
  end

  def create
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_varieties/new'
      end
    end

    _variety = BulkWineVariety.where(:code => params[:code])
    if _variety.present?
      flash[:error] = '品种编码不能重复，请修改'
      return render "/admin/bulk_wine_varieties/new"
    end

    params[:bulk_wine_variety] = params
    bulk_wine_variety = BulkWineVariety.create params.require(:bulk_wine_variety).permit(*BulkWineVariety.attrs)
    flash[:success] = '品种添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @bulk_wine_variety.blank?
      flash[:error] = '不存在该品种'
      return redirect_to session[:list_url]
    end
    {
      :code => '请填编码',
      :name_zh => '请填写中文名',
      :name_en => '请填写英文名',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_varieties/edit'
      end
    end

    _variety = BulkWineVariety.where(:code => params[:code]).where.not(id: @bulk_wine_variety.id)
    if _variety.present?
      flash[:error] = '品种编码不能重复，请修改'
      return redirect_to "/admin/bulk_wine_varieties/#{@bulk_wine_variety.id}/edit"
    end

    params[:bulk_wine_variety] = params
    @bulk_wine_variety.update params.require(:bulk_wine_variety).permit(*BulkWineVariety.attrs)
    flash[:success] = '品种编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    used = BulkWine.where(is_delete: 0).where('variety_id_one = ? or variety_id_two = ? or variety_id_three = ?', @bulk_wine_variety.id, @bulk_wine_variety.id, @bulk_wine_variety.id).first
    if used.present?
      flash[:error] = '品种已使用，不能删除。'
      return redirect_to session[:list_url]
    end

    @bulk_wine_variety.update :is_delete => 1
    flash[:success] = '品种删除成功！'
    redirect_to session[:list_url]
  end


  private
  def find_model
    @bulk_wine_variety = BulkWineVariety.find(params[:id]) if params[:id]
  end
end
