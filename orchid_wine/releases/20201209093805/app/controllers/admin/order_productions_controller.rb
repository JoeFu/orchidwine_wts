class Admin::OrderProductionsController < Admin::ApplicationController
  before_action :find_model

  def new
    @order = Order.find(params[:order_id]) rescue nil
    if @order.blank?
      return render :json => {:code => 0, :message => '<p>参数错误！</p><p class="text-warning">请先填写客户信息！</p>'}
    end

    args = {
      :is_delete => 1,
      :order_id => @order.id,
      :package => '6x750ml'
    }

    if params[:is_hb].to_i == 1
      args[:is_hb] = 1
    end

    @order_production = OrderProduction.create args
    redirect_to "/admin/order_productions/#{@order_production.id}/modal"
  end

  def modal
    @bulk_wine_stock = @order_production.bulk_wine.stock rescue nil
    @order = @order_production.order
    @bottle_type = @order_production.bottle_code.last rescue 'C'
    render layout: false
  end

  def ajax_update
    @order = @order_production.order

    if params[:production_num].to_i < 1
      @order_production.destroy
      return render :json => {:code => 0, :message => '参数错误！订货数量不正确！'}
    end

    is_hb = params[:is_hb].to_i
    if is_hb == 0
      bulk_wine = nil
      if @order.status == 0
        bulk_wine = BulkWine.where(code: params[:bulk_wine_code], status: 1, is_delete: 0).first
        if bulk_wine.blank?
          return render :json => {:code => 0, :message => '参数错误！'}
        end
        params[:bulk_wine_id] = bulk_wine.id
        params[:bulk_wine_desc] = bulk_wine.desc
      else
        bulk_wine = @order_production.bulk_wine
      end

      # 购物车也不能下超了
      if @order.status == 0
        if params[:production_num].to_i > bulk_wine.stock.stock
          return render :json => {:code => 0, :message => '参数错误！订货数量超过库存，无法保存！'}
        end
      end

      if @order.status_tmp?
        # 不是购物车订单，修改数量的时候库存要考虑加上自己原来的扣除量
        if params[:production_num].to_i > bulk_wine.stock.stock + @order_production.production_num
          return render :json => {:code => 0, :message => '参数错误！订货数量超过库存，无法保存！'}
        end
      end

      # 判断是不是 too little?
      if params[:production_num].to_i < bulk_wine.stock.min_number
        params[:too_little] = 1
      else
        params[:too_little] = 0
      end
    end

    if OrderProduction::PACKAGE_COUNT[params[:package]].blank?
      @order_production.destroy
      return render :json => {:code => 0, :message => '参数错误！请选择包装方式！'}
    end

    params[:is_delete] = 0

    divider = Divider.where(:id => params[:divider_id]).first
    if divider.present?
      params[:divider_id] = divider.id
      params[:divider_desc] = divider.divider_type
    end

    carton = Carton.find(params[:carton_id]) rescue nil
    if carton.present?
      params[:carton_desc] = carton.desc
    end

    bottle = Bottle.find(params[:bottle_id]) rescue nil
    if bottle.blank?
      @order_production.destroy
      return render :json => {:code => 0, :message => '参数错误！请选择瓶型！'}
    end

    params[:bottle_code] = bottle.bottle_code

    # 酒帽
    cap = Cap.find(params[:cap_id]) rescue nil
    if cap.present?
      params[:cap_desc] = cap.desc
    end

    # 螺旋盖 BVS
    if bottle.bottle_code.last == 'B'
      params[:cork_id] = nil
      params[:cork_desc] = nil
    end

    # 木塞 Cork
    if bottle.bottle_code.last == 'C'
      cork = Cork.find(params[:cork_id]) rescue nil
      params[:cork_desc] = cork.desc if cork.present?
    end

    params[:user_id] = @order_production.order.user_id
    params[:order_production] = params


    attrs = OrderProduction.attrs
    # 下单之后，不能编辑产品和数量
    if @order.status > 0
      attrs -= [:bulk_wine_id, :bulk_wine_code, :bulk_wine_desc]
      if !@order.status_tmp?
        attrs -= [:production_num]
      end
    end

    @order_production.update params.require(:order_production).permit(*attrs)
    # @order_production.update :unit_price => '%.2f' % @order_production.total_price

    @order.update :total_bottle_num => @order.order_productions.sum(:production_num)
    @order.update_total_price

    url = request.referer
    url = "/admin/orders/#{@order.id}/edit" if @order.status_tmp?
    query = URI(request.referer).query
    query = 'step=2' if query.blank?
    url += '?'+ query
    render :json => {:code => 1, :result => 'success', :url => url }
  end

  def destroy
    @order = @order_production.order
    @order_production.destroy
    
    @order.update :total_bottle_num => @order.order_productions.sum(:production_num)
    @order.update_total_price

    url = request.referer
    url = "/admin/orders/#{@order.id}/edit" if @order.status_tmp?
    query = URI(request.referer).query
    query = 'step=2' if query.blank?
    url += '?' + query
    redirect_to url
  end

  def produce_type
    @order_production.update :produce_type => params[:produce_type]
    render :json => {:code => 1}
  end

  def change_bottle_type
    @order_production = OrderProduction.new if @order_production.blank?
    if params[:bottle_type] == 'B'
      return render "admin/order_productions/_b_bottle", layout: false
    end
    return render "admin/order_productions/_c_bottle", layout: false
  end

  private
  def find_model
    @order_production = OrderProduction.find(params[:id]) if params[:id]
  end
end
