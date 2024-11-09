# encoding: utf-8
class Admin::ImportCompaniesController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions, values = [], []
    if params[:q].present?
      conditions << 'name like ?'
      values << "%#{params[:q]}%"
    end

    if @admin_session.role == 2
      conditions << 'admin_id = ?'
      values << @admin_session.id
    end

    @import_companies = ImportCompany.where(conditions.join(' or '), *values)
    .limit(Const::ADMIN_PAGE_SIZE)
    .order('id desc')
    .page(params[:page])
  end

  def create
    {
      :name => '请填写公司名称',
      :contacts => '请填写联系人',
      :telephone => '请填写电话号码',
      :email => '请填写电子邮箱',
      :uscc => '请填写社会统一信用代码',
      :address => '请填写地址',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/import_companies/new'
      end
    end

    params[:import_company] = params
    @import_company = ImportCompany.create params.require(:import_company).permit(*ImportCompany.attrs)

    flash[:success] = '进口公司添加成功！'
    redirect_to session[:list_url]
  end

  def update
    {

      :name => '请填写公司名称',
      :contacts => '请填写联系人',
      :telephone => '请填写电话号码',
      :email => '请填写电子邮箱',
      :uscc => '请填写社会统一信用代码',
      :address => '请填写地址',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/import_companies/edit'
      end
    end

    if @import_company.blank?
      flash[:error] = '编辑失败'
      return redirect_to session[:list_url]
    end

    params[:import_company] = params
    @import_company.update params.require(:import_company).permit(*ImportCompany.attrs)

    flash[:success] = '编辑进口公司信息成功！'
    redirect_to session[:list_url]
  end

  # [进口公司] 删除进口公司
  def destroy
    @import_company.destroy
    flash[:success] = '进口公司删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @import_company = ImportCompany.find(params[:id]) if params[:id]
  end
end
