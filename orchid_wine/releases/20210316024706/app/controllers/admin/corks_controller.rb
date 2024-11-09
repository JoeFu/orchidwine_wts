class Admin::CorksController < Admin::ApplicationController
  before_action :find_model

  def index
    @corks = Cork.where(:is_delete => 0)
    @caps =Cap.where(:is_delete => 0)
  end

  def create
    {
      :texture_code => '请填写材质编码',
      :texture_des => '请填写材质描述',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/corks/new'
      end
    end
    if Cork.where(:texture_code => params[:texture_code]).present?
      flash[:error] = '材质编码不能重复'
      return render '/admin/corks/new'
    end
    params[:cork] = params
    @cork = Cork.create params.require(:cork).permit(*Cork.attrs)
    redirect_to session[:list_url]
  end

  def update
    if @cork.blank?
      flash[:error] = '不存在该酒塞'
      return redirect_to "/admin/corks"
    end

    {
      :texture_code => '请填写材质编码',
      :texture_des => '请填写材质描述',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/corks/edit'
      end
    end
    _cork = Cork.where(:texture_code => params[:texture_code]).where.not(:id => @cork.id)
    if _cork.present?
      flash[:error] = '编码不能重复'
      return redirect_to '/admin/corks'
    end

    params[:cork] = params
    @cork.update params.require(:cork).permit(*Cork.attrs)
    flash[:success] = '酒塞编辑成功'
    redirect_to session[:list_url]
  end

  def destroy
    @cork.update :is_delete => 1
    flash[:success] = '酒塞删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @cork = Cork.find(params[:id]) if params[:id]
  end
end
