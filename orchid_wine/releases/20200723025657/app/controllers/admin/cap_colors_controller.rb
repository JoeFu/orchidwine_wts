class Admin::CapColorsController < Admin::ApplicationController
  before_action :find_model

  def index
    @cap_colors =CapColor.where(:is_delete => 0)
    .order('id desc')
  end

  def create
    {
      :color_code => '请填编号',
      :color_value => '请填写酒帽标准色值',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/cap_colors/new'
      end
    end

    params[:operate_id] = @admin_session.id #创建者ID
    params[:operate_rank] = 1 #创建者身份 1-管理员 2-客户

    params[:cap_color] = params
    cap_color =CapColor.create params.require(:cap_color).permit(*CapColor.attrs)
    flash[:success] = '酒帽颜色添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @cap_color.blank?
      flash[:error] = '不存在该酒帽颜色'
      return redirect_to session[:list_url]
    end
    {
      :color_code => '请填编号',
      :color_value => '请填写酒帽标准色值',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/cap_colors/edit'
      end
    end

    params[:operate_id] = @admin_session.id #创建者ID
    params[:operate_rank] = 1 #创建者身份 1-管理员 2-客户

    params[:cap_color] = params
    @cap_color.update params.require(:cap_color).permit(*CapColor.attrs)
    flash[:success] = '酒帽颜色编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    @cap_color.update :is_delete => 1
    flash[:success] = '酒帽颜色删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @cap_color =CapColor.find(params[:id]) if params[:id]
  end
end
