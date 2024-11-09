class Admin::CartonsController < Admin::ApplicationController
  before_action :find_model

  def index
    @cartons =Carton.where(:is_delete => 0)
  end

  def create
    {
      :desc => '请填写描述',
      :bottle_number => '请填写支数',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/cartons/new'
      end
    end

    unless /^[1-9]\d*$/.match(params[:bottle_number]).present?
      flash[:error] = '支数只能为正整数'
      return render "/admin/cartons/new"
    end

    # params[:desc] = params[:bottle_number].to_i.to_s + "支装"

    params[:box] = params
    box =Carton.create params.require(:box).permit(*Carton.attrs)

    flash[:success] = '纸箱添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @carton.blank?
      flash[:error] = '不存在该纸箱'
      redirect_to session[:list_url]
    end

    {
      :desc => '请填写描述',
      :bottle_number => '请填写支数',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/cartons/edit'
      end
    end

    unless /^[1-9]\d*$/.match(params[:bottle_number]).present?
      flash[:error] = '支数只能为正整数'
      return render "/admin/cartons/new"
    end

    params[:box] = params
    @carton.update params.require(:box).permit(*Carton.attrs)
    flash[:success] = '纸箱编辑成功'
    redirect_to session[:list_url]
  end

  def destroy
    @carton.update :is_delete => 1
    flash[:success] = '纸箱删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @carton =Carton.find(params[:id]) if params[:id]
  end
end
