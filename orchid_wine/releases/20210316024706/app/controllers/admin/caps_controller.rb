class Admin::CapsController < Admin::ApplicationController
  before_action :find_model

  def create
    {
      :type_code => '请填写类型编码',
      :type_des => '请填写类型描述',
      :texture_code => '请填写材质编码',
      :texture_des => '请填写材质描述'
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/caps/new'
      end
    end
    params[:cap] = params
    Cap.create params.require(:cap).permit(*Cap.attrs)
    flash[:success] = '新建成功'
    redirect_to session[:list_url]
  end

  def update
    if @cap.blank?
      flash[:error] = '不存在该酒帽'
      return redirect_to '/admin/caps'
    end
    {
      :type_code => '请填写类型编码',
      :type_des => '请填写类型描述',
      :texture_code => '请填写材质编码',
      :texture_des => '请填写材质描述'
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/caps/edit'
      end
    end
    params[:cap] = params
    @cap.update params.require(:cap).permit(*Cap.attrs)
    flash[:success] = '酒帽编辑成功'
    redirect_to session[:list_url]
  end

  def destroy
    @cap.update :is_delete => 1
    flash[:success] = '酒帽删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @cap = Cap.find(params[:id]) if params[:id]
  end
end
