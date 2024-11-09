class Admin::WebProductCategoriesController < Admin::ApplicationController
  before_action :find_model

  def index
    @web_product_categories = ::WebProductCategory.all
    .order('sort ASC')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    if params[:name].blank?
      flash[:error] = '名称不能为空！'
      return render '/admin/web_product_categories/new'
    end
    if WebProductCategory.where(name: params[:name]).present?
      flash[:error] = '分类已被添加！'
      return render '/admin/web_product_categories/new'
    end

    params[:cate] = params
    WebProductCategory.create params.require(:cate).permit(*WebProductCategory.attrs)

    flash[:success] = '产品分类添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @web_product_category.blank?
      flash[:error] = '分类不存在！'
      return redirect_to '/admin/web_product_categories'
    end

    if params[:name].blank?
      flash[:error] = '名称不能为空！'
      return redirect_to '/admin/web_product_categories'
    end

    if WebProductCategory.where(name: params[:name]).where.not(id:@web_product_category.id).present?
      flash[:error] = '分类已被添加！'
      return redirect_to '/admin/web_product_categories'
    end

    params[:web_product_category] = params
    @web_product_category.update params.require(:web_product_category).permit(*WebProductCategory.attrs)
    
    flash[:success] = '产品分类编辑成功！'
    redirect_to session[:list_url]
  end

  def destroy
    if @web_product_category.blank?
      flash[:error] = '分类不存在！'
    end

    if @web_product_category.web_products.present?
      flash[:error] = '该分类下有产品，不能删除！'
    else
      @web_product_category.destroy
    end

    redirect_to session[:list_url]
  end

  private
  def find_model
    @web_product_category = WebProductCategory.find_by(id: params[:id]) if params[:id]
  end
end
