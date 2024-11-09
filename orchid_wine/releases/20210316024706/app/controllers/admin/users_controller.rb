# encoding: utf-8
class Admin::UsersController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions = []
    values = []
    if params[:q].present?
      conditions << 'name like ?'
      values << "%#{params[:q]}%"
    end

    if @admin_session.role == 2
      conditions << 'admin_id = ?'
      values << @admin_session.id
    end

    @users = User.where(conditions.join(' and '), *values)
    .order('id desc')
    .preload(:orders, :admin)
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      :user_name => '请填写登录名称',
      :name => '请填写真实姓名',
      :sex => '请选择性别',
      # :role => '请选择客户类型',
      :company => '请填写公司名称',
      :company_code => '请填写公司编码',
      :telphone => '请填写联系电话',
      :email => '请填写电子邮箱',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/users/new'
      end
    end

    params[:company_code] = params[:company_code].upcase
    params[:email] = params[:email].downcase

    if (User.find_by(:user_name => params[:user_name])).present?
      flash[:error] = '客户代码已被其他客户使用，请更改'
      return render '/admin/users/new'
    end

    if (User.find_by(:company_code => params[:company_code])).present?
      flash[:error] = '公司编码已被其他客户使用，请更改'
      return render '/admin/users/new'
    end

    if (User.find_by(:email => params[:email])).present?
      flash[:error] = '邮箱已被其他客户使用，请更改'
      return render '/admin/users/new'
    end

    params[:user] = params
    user = User.create params.require(:user).permit(*User.attrs)

    flash[:success] = '客户添加成功！'
    redirect_to '/admin/users'
  end

  def update
    {
      :name => '请填写真实姓名',
      :sex => '请选择性别',
      :company => '请填写公司名称',
      :company_code => '请填写公司编码',
      :telphone => '请填写联系电话',
      :email => '请填写电子邮箱',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render "/admin/users/edit"
      end
    end

    params[:company_code] = params[:company_code].upcase
    params[:email] = params[:email].downcase

    other_user = User.where(:company_code => params[:company_code]).where.not(:id => @user.id)
    if other_user.present?
      flash[:error] = '公司编码已被其他客户使用，请更改'
      return redirect "/admin/users/#{@user.id}/edit"
    end

    params[:user] = params
    @user.update params.require(:user).permit(*User.attrs)

    @user.orders.update_all seller_id: @user.admin_id
    flash[:success] = '编辑成功'
    return redirect_to '/admin/users'
  end

  # def reset_password
  #   @this_user = User[params[:user_id]]
  #   if @this_user.blank?
  #     flash[:error] = '不存在该用户'
  #     redirect_to '/admin/users'
  #   end

  #   @this_user.password = nil
  #   @this_user.encrypt_password
  #   @this_user.save

  #   redirect env['HTTP_REFERER'], :success => '密码重置成功'
  # end

  def show
    
  end

  def destroy
    if @user.blank?
      flash[:error] = '删除失败，客户未找到！'
      return redirect_to '/admin/users'
    end

    if !@user.orders.size.zero?
      flash[:error] = '该客户有订单，不能删除！'
      return redirect_to '/admin/users'
    end

    @user.destroy
    flash[:success] = '客户删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @user = User.find_by(id: params[:id]) if params[:id]
  end
end
