class Admin::DividersController < Admin::ApplicationController
  before_action :find_model

  def index
    @dividers =Divider.where(:is_delete => 0)
  end

  def create
    {
      :divider_code => '分隔板编码',
      :divider_type => '分隔板描述',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/dividers/new'
      end
    end
    params[:divider] = params
    divider =Divider.create params.require(:divider).permit(*Divider.attrs)
    flash[:success] = '分隔板添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @divider.blank?
      flash[:error] = '不存在该分隔板'
      return redirect_to '/admin/dividers'
    end

    {
      :divider_code => '分隔板编码',
      :divider_type => '分隔板描述',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/dividers/edit'
      end
    end
    params[:divider] = params
    @divider.update params.require(:divider).permit(*Divider.attrs)

    flash[:success] = '分隔板编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    @divider.update :is_delete => 1
    flash[:success] = '分隔板删除成功！'
    redirect_to session[:list_url]
  end


  private
  def find_model
    @divider =Divider.find(params[:id]) if params[:id]
  end
end
