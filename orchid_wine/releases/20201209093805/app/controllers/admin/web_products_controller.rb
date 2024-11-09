class Admin::WebProductsController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions = []
    values = []
    if params[:q].present?
      conditions << 'name like ?'
      values << "%#{params[:q]}%"
    end

    @web_products = WebProduct.where(conditions.join(' and '), *values)
    .preload(:web_product_category)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      name: '名称',
      score: '评分',
      grape_variety: '葡萄品种',
      grape_area: '葡萄产区',
      wine_maker: '酿酒师',
      taste: '入口滋味',
      match: '餐饮搭配',
      feature: '产品特点',
    }.each do |k,v|
      if params[k].blank?
        flash[:error] = "#{v}不能为空！"
        return render '/admin/web_products/new'
      end
    end

    params[:product] = params
    WebProduct.create params.require(:product).permit(*WebProduct.attrs)
    redirect_to '/admin/web_products'
  end

  def update
    if @web_product.blank?
      flash[:error] = '产嵓不存在！'
      return redirect_to session[:list_url]
    end

    params[:web_product] = params
    @web_product.update params.require(:web_product).permit(*WebProduct.attrs)
    redirect_to session[:list_url]
  end

  def destroy
    if @web_product.blank?
      flash[:error] = '产嵓不存在！'
    end

    @web_product.destroy
    redirect_to session[:list_url]
  end

  private
  def find_model
    @web_product = WebProduct.find_by(id: params[:id]) if params[:id]
  end
end
