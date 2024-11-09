# encoding: utf-8
class Admin::AdminsController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions, values = [], []
    if params[:q].present?
      conditions << 'true_name like ?'
      values << "%#{params[:q]}%"

      conditions << 'mobile like ?'
      values << "%#{params[:q]}%"
    end

    @admins = Admin.where(conditions.join(' or '), *values).where(:is_delete => 0)
    .limit(Const::ADMIN_PAGE_SIZE)
    .order('id desc')
    .page(params[:page])
  end

  def create
    {
      :user_name => '请填写登录名称',
      :true_name => '请填写真实姓名',
      :mobile => '请填写手机号码',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/admins/new'
      end
    end
    if (Admin.find_by(:user_name => params[:user_name])).present?
      flash[:error] = '登录名称已存在，请更改'
      return render '/admin/admins/new'
    end

    params[:admin] = params
    @admin = Admin.create params.require(:admin).permit(*Admin.attrs)

    flash[:success] = '管理员添加成功！'
    redirect_to session[:list_url]
  end

  def update
    {
      :user_name => '请填写登录名称',
      :true_name => '请填写真实姓名',
      :mobile => '请填写手机号码',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/admins/edit'
      end
    end

    if @admin.blank?
      flash[:error] = '编辑失败'
      return redirect_to session[:list_url]
    end

    if @admin_session.role == 0 && params[:password].present?
      @admin.password = params[:password]
      @admin.encrypt_password
      @admin.save
    end

    params[:admin] = params.except(:password)
    @admin.update params.require(:admin).permit(*Admin.attrs)

    flash[:success] = '编辑管理员信息成功！'
    redirect_to session[:list_url]
  end

  # [管理员] 删除管理员
  def destroy
    if (@admin = Admin.find_by(id: params[:id])).blank?
      flash[:error] = '删除失败，管理员未找到！'
      return redirect_to '/admin/admins'
    end

    @admin.update :is_delete => 1
    flash[:success] = '管理员删除成功！'
    redirect_to session[:list_url]
  end

  def passwd_post
    {
      :old_password => '原密码不能为空！',
      :new_password => '新密码不能为空！',
      :confirm_new_password => '新密码确认不能为空！',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render "/admin/admins/passwd"
      end
    end

    old_password = params[:old_password]
    new_password = params[:new_password]
    confirm_new_password = params[:confirm_new_password]

    if new_password != confirm_new_password
      flash[:error] = '密码修改失败，两次输入的新密码不一致！'
      return redirect_to request.referer
    end

    unless @admin.password_validate?(old_password)
      flash[:error] = '密码修改失败，您输入的原密码不正确！'
      return redirect_to request.referer
    end

    @admin.password = new_password
    @admin.encrypt_password
    @admin.save

    flash[:success] = '密码修改成功，请牢记您的新密码！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @admin = Admin.find(params[:id]) if params[:id]
  end
end
