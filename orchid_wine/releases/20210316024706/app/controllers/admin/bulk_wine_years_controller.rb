class Admin::BulkWineYearsController < Admin::ApplicationController
  before_action :find_model

  def index
    @bulk_wine_years = BulkWineYear.where(:is_delete => 0).order('year desc')
  end

  def create
    {
      :year => '请填年份',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/bulk_wine_years/new'
      end
    end


    _year = BulkWineYear.where(:year => params[:year])
    if _year.present?
      flash[:error] = '年份不能重复，请修改'
      return render'/admin/bulk_wine_years/new'
    end

    params[:bulk_wine_year] = params
    bulk_wine_year = BulkWineYear.create params.require(:bulk_wine_year).permit(*BulkWineYear.attrs)
    flash[:success] = '年份添加成功！'
    redirect_to session[:list_url]
  end

  def destroy
    @bulk_wine_year.update :is_delete => 1
    flash[:success] = '年份删除成功！'
    redirect_to session[:list_url]
  end


  private
  def find_model
    @bulk_wine_year = BulkWineYear.find(params[:id]) if params[:id]
  end
end
