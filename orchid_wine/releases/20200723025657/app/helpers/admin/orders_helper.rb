module Admin::OrdersHelper

  # def order_conditions_values
  #   conditions, values =[], []
  #   if params[:user_name].present?
  #     user_ids = User.where('name like ?', "%#{params[:user_name]}%").ids
  #     conditions << 'user_id in (?)'
  #     values << user_ids
  #   end

  #   @filter_order_production_ids = nil
  #   if params[:bulk_wine_id].to_i > 0
  #     @filter_order_production_ids = OrderProduction.where(bulk_wine_id: params[:bulk_wine_id].to_i).ids
  #     order_ids = OrderProduction.where(bulk_wine_id: params[:bulk_wine_id].to_i).pluck('order_id')
  #     conditions << 'id in (?)'
  #     values << order_ids.compact.uniq
  #   else
  #     if params[:bulk_wine_sort_id].to_i > 0 ||
  #         params[:bulk_wine_vendor_id].to_i > 0 ||
  #         params[:bulk_wine_variety_id].to_i > 0 ||
  #         BulkWineYear.options.include?(params[:bulk_wine_year])

  #       bk_conditions, bk_values =[], []
  #       if params[:bulk_wine_sort_id].to_i > 0
  #         bk_conditions << 'sort_id = ?'
  #         bk_values << params[:bulk_wine_sort_id].to_i
  #       end

  #       if params[:bulk_wine_vendor_id].to_i > 0
  #         bk_conditions << 'vendor_id = ?'
  #         bk_values << params[:bulk_wine_vendor_id].to_i
  #       end

  #       if params[:bulk_wine_variety_id].to_i > 0
  #         bk_conditions << 'variety_id_one = ? or variety_id_two = ? or variety_id_three = ?'
  #         bk_values << params[:bulk_wine_variety_id].to_i
  #         bk_values << params[:bulk_wine_variety_id].to_i
  #         bk_values << params[:bulk_wine_variety_id].to_i
  #       end

  #       if BulkWineYear.options.include?(params[:bulk_wine_year])
  #         bk_conditions << 'year = ?'
  #         bk_values << params[:bulk_wine_year]
  #       end

  #       bulk_wine_ids = BulkWine.where(bk_conditions.join(' and '), *bk_values).ids
  #       @filter_order_production_ids = OrderProduction.where(bulk_wine_id: bulk_wine_ids).ids
  #       order_ids = OrderProduction.where(bulk_wine_id: bulk_wine_ids).pluck('order_id')
  #       conditions << 'id in (?)'
  #       values << order_ids.compact.uniq
  #     end
  #   end

  #   if params[:order_number].present?
  #     conditions << 'order_number like ?'
  #     values << "%#{params[:order_number]}%"
  #   end

  #   # if params[:sort].to_i.in?([1,2])
  #   #   conditions << 'sort = ?'
  #   #   values << params[:sort].to_i
  #   # end

  #   # 各状态页面
  #   if params[:status].to_i > 0
  #     if params[:status].to_i.in?([3, 4])
  #       conditions << 'status in (3, 4)'
  #     elsif params[:status].to_i.in?([4, 5, 6])
  #       conditions << 'status in (4, 5)'
  #     else
  #       conditions << 'status = ?'
  #       values << params[:status].to_i
  #     end
  #   end

  #   # 汇总页面
  #   if params[:status].to_i == 0
  #     params[:search_status] = 99 if params[:search_status].blank?

  #     search_status = {
  #       99 => [1,2,3,4,5],
  #       0 => [0,1,2,3,4,5],
  #       1 => [1],
  #       2 => [2],
  #       3 => [3,4],
  #       4 => [3,4],
  #       5 => [4],
  #       6 => [4,5],
  #       7 => [5],
  #     }

  #     conditions << 'status in (?)'
  #     values << search_status[params[:search_status].to_i]
  #   end

  #   conditions << 'status != 9'

  #   if @admin_session.role == 2
  #     conditions << "seller_id = ?"
  #     values << @admin_session.id
  #   elsif params[:seller_id].to_i > 0
  #     conditions << "seller_id = ?"
  #     values << params[:seller_id]
  #   end

  #   if params[:bottle_code].present?
  #     if @filter_order_production_ids.nil?
  #       @filter_order_production_ids = OrderProduction.where(bulk_wine_id: bulk_wine_ids).ids
  #     else
  #       @filter_order_production_ids = @filter_order_production_ids & OrderProduction.where(bottle_code: params[:bottle_code]).ids
  #     end

  #     order_ids = OrderProduction.where(bottle_code: params[:bottle_code]).pluck('order_id')
  #     conditions << 'id in (?)'
  #     values << order_ids.compact.uniq
  #   end

  #   [conditions, values]
  # end

  def table_order_productions
    conditions, values =[], []
    if params[:user_name].present?
      user_ids = User.where('name like ?', "%#{params[:user_name]}%").ids
      conditions << 'user_id in (?)'
      values << user_ids
    end

    if params[:order_number].present?
      conditions << 'order_number like ?'
      values << "%#{params[:order_number]}%"
    end

    # 各状态页面
    if params[:status].to_i > 0
      if params[:status].to_i.in?([3, 4])
        conditions << 'status in (3, 4)'
      elsif params[:status].to_i.in?([4, 5, 6])
        conditions << 'status in (4, 5)'
      else
        conditions << 'status = ?'
        values << params[:status].to_i
      end
    end

    # 汇总页面
    if params[:status].to_i == 0
      params[:search_status] = 99 if params[:search_status].blank?

      search_status = {
        99 => [1,2,3,4,5],
        0 => [0,1,2,3,4,5],
        1 => [1],
        2 => [2],
        3 => [3,4],
        4 => [3,4],
        5 => [4],
        6 => [4,5],
        7 => [5],
      }

      conditions << 'status in (?)'
      values << search_status[params[:search_status].to_i]
    end

    conditions << 'status != 9'

    if @admin_session.role == 2
      conditions << "seller_id = ?"
      values << @admin_session.id
    elsif params[:seller_id].to_i > 0
      conditions << "seller_id = ?"
      values << params[:seller_id]
    end

    order_ids = Order.where(conditions.join(' and '), *values).ids

    op_conditions, op_values =[], []
    op_conditions << 'order_id in (?)'
    op_values << order_ids

    if params[:bulk_wine_id].to_i > 0
      op_conditions << 'bulk_wine_id = ?'
      op_values << params[:bulk_wine_id]
    else
      if params[:bulk_wine_sort_id].to_i > 0 ||
          params[:bulk_wine_vendor_id].to_i > 0 ||
          params[:bulk_wine_variety_id].to_i > 0 ||
          BulkWineYear.options.include?(params[:bulk_wine_year])

        bk_conditions, bk_values =[], []
        if params[:bulk_wine_sort_id].to_i > 0
          bk_conditions << 'sort_id = ?'
          bk_values << params[:bulk_wine_sort_id].to_i
        end

        if params[:bulk_wine_vendor_id].to_i > 0
          bk_conditions << 'vendor_id = ?'
          bk_values << params[:bulk_wine_vendor_id].to_i
        end

        if params[:bulk_wine_variety_id].to_i > 0
          bk_conditions << 'variety_id_one = ? or variety_id_two = ? or variety_id_three = ?'
          bk_values << params[:bulk_wine_variety_id].to_i
          bk_values << params[:bulk_wine_variety_id].to_i
          bk_values << params[:bulk_wine_variety_id].to_i
        end

        if BulkWineYear.options.include?(params[:bulk_wine_year])
          bk_conditions << 'year = ?'
          bk_values << params[:bulk_wine_year]
        end

        bulk_wine_ids = BulkWine.where(bk_conditions.join(' and '), *bk_values).ids
        op_conditions << 'bulk_wine_id in (?)'
        op_values << bulk_wine_ids
      end
    end

    if params[:bottle_code].present?
      op_conditions << 'bottle_code = ?'
      op_values << params[:bottle_code]
    end

    if params[:search_status].present?
      case params[:search_status].to_i
      when 3
        op_conditions << 'produced = 0'
      when 4
        op_conditions << 'produced = 1'
      when 5
        op_conditions << 'produced in (2,3)'
        op_conditions << 'shipped = 0'
      when 6
        op_conditions << 'shipped = 1'
        op_conditions << 'paid = 0'
      when 7
        op_conditions << 'paid = 1'
      when 99
        op_conditions << 'paid = 0'
      end
    end

    case params[:status].to_i
    when 3
      op_conditions << 'produced = 0'
    when 4
      op_conditions << 'produced = 1'
    when 5
      op_conditions << 'produced in (2,3)'
      op_conditions << 'paid = 0'
    when 6
      op_conditions << 'paid = 1'
    end

    @order_productions = OrderProduction.where(op_conditions.join(' and '), *op_values)
    .preload(:order, :user, :seller, :bulk_wine)
    .order('order_id desc')
  end


  def order_counter
    counter_conditions = []
    counter_conditions << 'status in (1,2,3,4,5)'
    if @admin_session.role == 2
      counter_conditions << "seller_id = #{@admin_session.id}"
    end
    @all_order_count = Order.where(counter_conditions.join(' and ')).count
    @status_count = {}
    Order.select('count(*) as total,status').where(counter_conditions.join(' and ')).group(:status)
    .map do |cou|
      @status_count[cou.status] = cou.total
    end

    order34_ids = Order.where(status: [3, 4]).ids
    if @admin_session.role == 2
      order34_ids = Order.where(status: [3, 4], seller_id: @admin_session.id).ids
    end
    @status_count[3] = OrderProduction.where(order_id: order34_ids, produced: 0).count
    @status_count[4] = OrderProduction.where(order_id: order34_ids, produced: 1).count
    
    @status_count[5] = OrderProduction.where(produced: [2, 3], paid: 0).count
    @status_count[6] = OrderProduction.where(produced: [2, 3], paid: 1).count
    if @admin_session.role == 2
      order45_ids = Order.where(status: [4, 5], seller_id: @admin_session.id).ids
      @status_count[5] = OrderProduction.where(order_id: order45_ids, produced: [2, 3], paid: 0).count
      @status_count[6] = OrderProduction.where(order_id: order45_ids, produced: [2, 3], paid: 1).count
    end
  end
end
