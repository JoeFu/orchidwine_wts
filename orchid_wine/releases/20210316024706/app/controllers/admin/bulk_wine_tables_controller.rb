class Admin::BulkWineTablesController < Admin::ApplicationController

  include TagHelper

  def data
    conditions, values = [], []
    if params[:q].present?
      conditions << 'code like ?'
      values << "%#{params[:q]}%"
    end

    if params[:desc].present?
      conditions << '`desc` like ?'
      values << "%#{params[:desc]}%"
    end

    if params[:sort_id].present?
      conditions << '`sort_id` = ?'
      values << params[:sort_id]
    end

    # if params[:year].present?
    #   conditions << 'year = ?'
    #   values << params[:year]
    # end

    # if params[:vendor].present?
    #   vendors = BulkWineVendor.where('name like ?',  "%#{params[:vendor]}%")
    #   conditions << 'vendor_id in (?)'
    #   values << vendors.ids
    # end

    conditions << 'is_delete = 0'
    conditions << 'status = 1'

    bulk_wine_ids = BulkWine.where(conditions.join(' and '), *values).ids
    @bulk_wine_stocks = BulkWineStock.where(bulk_wine_id: bulk_wine_ids)
    .preload(:bulk_wine, :cap, :bottle, :cork, :divider, :carton)
    .order('id desc')

    order_ids = Order.where(status: 0).ids
    @sellings = {}
    OrderProduction.where(order_id: order_ids, bulk_wine_id: bulk_wine_ids)
    .map do |order_production|
      @sellings[order_production.bulk_wine_id] ||= 0
      @sellings[order_production.bulk_wine_id] += order_production.real_num
    end

    @bluk_wines = []
    @bulk_wine_stocks.map do |bk_stock|
      bulk_wine = bk_stock.bulk_wine
      args = {
        code: bulk_wine.code,
        desc: bulk_wine.desc,
        price: bulk_wine.price,
        cost: bulk_wine.cost,

        total_stock: bk_stock.total_stock.ts,
        sold_count: bk_stock.sold_count.ts,
        can_sell_stock: bk_stock.can_sell_stock.ts,
        sellings: 0,
        min_number:bk_stock.min_number.ts,
        custom_number:bk_stock.custom_number.ts,
      }

      if @sellings[bk_stock.bulk_wine_id].present?
        args[:sellings] = @sellings[bk_stock.bulk_wine_id].ts
      end

      if @admin_session.role != 2
        args[:code] = "<a class=\"btn-link\" href=\"/admin/bulk_wines/#{bulk_wine.id}?bulk_wine_id=#{bulk_wine.id}\">#{bulk_wine.code}</a>"
        args[:show_btn] = show_btn_tag(bk_stock, nil, '标准品信息')
        args[:add_stock_btn] = a_get_tag("添加库存", "/admin/bulk_wine_stocks/#{bk_stock.id}/stock", 'info', 'ion-plus-round')
        args[:edit_btn] = edit_btn_tag(bk_stock)


        if @sellings[bk_stock.bulk_wine_id].present?
          args[:sellings] = "<a target=\"_blank\" class=\"btn-link\" href=\"/admin/quotations?utf8=✓&bulk_wine_id=#{bk_stock.bulk_wine_id}&sort=1\">#{@sellings[bk_stock.bulk_wine_id].ts}</a>"
        end
      end


      @bluk_wines << args
    end
  end
end
