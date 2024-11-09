module Admin::AuthorityHelper

  def can?(action, controller)
    return can_ability(@admin_session.role, action, controller)
    false
  end

  def can_ability(role, action, controller)
    configs = {
      # 超级管理员
      0 => {
        :All => true,
        :Order => {:except => [:create]},
        :OrdersNew => false,
      },
      # 系统管理员
      1 => {
        :All => true,
        :OrdersNew => false,
        :Order => {:except => [:create]},
        # :WebProduct => false,
        # :WebProductCategory => false,
      },
      # 销售
      2 => {
        :Dashboard => true,
        :Main => true,
        :User => true,
        :Quotation => true,
        :OrdersNew => true,
        :Order => {:only => [:create, :index, :destroy, :edit, :show, :update, :submit, :cancel_submit, :confirm, :restore, :renew]},
        :OrderTable => true,
        :OrderProduction => true,
        :BulkWineStock => {:only => [:get_json]},
        :BulkWineTable => true,
        :ImportCompany => true,
        :Upload => true,
        :BulkWine => {:only => [:get_json]},
        :Bottle => {:only => [:select_options, :service_prices]},
      },
      # 物流主管
      3 => {
        :Main => true,
        :Order => {:only => [:index, :show, :edit, :update]},
        :OrderTable => true,
        :Delivery => true,
        :ImportCompany => true,
        :Upload => true,
        :Container => true,
      },
      # 财务主管
      4 => {
        :Dashboard => true,
        :Main => true,
        :Quotation => true,
        :Order => {:only => [:index, :show, :export, :recheck, :edit, :update, :pay]},
        :OrderTable => true,
        :Upload => true,
        :BulkWineStock => true,
        :BulkWineTable => true,
        :BulkWine => true,
      },
      # 生产主管
      5 => {
        :Main => true,
        :Dashboard => true,
        :Quotation => true,
        :Order => {:only => [:index, :show, :stockup, :edit, :update, :produced, :pay, :export, :confirm, :destroy]},
        :OrderTable => true,
        :OrderProduction => true,
        :Upload => true,
        :BulkWine => true,
        :BulkWineStock => true,
        :BulkWineTable => true,
        :BulkWineVendor => true,
        :BulkWineYear => true,
        :BulkWineArea => true,
        :BulkWineVariety => true,
        :BulkWineSort => true,
        
        :Cork => true,
        :Bottle => true,
        :Cap => true,
        :CapColor => true,
        :Divider => true,
        :Carton => true,

        :ImportCompany => true,
        # :Delivery => true,
        :Container => true,
      },
      6 => {
        :WebProductCategory => true,
        :WebProduct => true,
        :Upload => true,
      }

    }

    actions = configs[role][controller] rescue nil
    if actions.nil?
      return true if (configs[role].include?(:All) rescue false)
      return false
    end
    return true if actions.class == TrueClass
    return false if actions.class == FalseClass

    if actions[:except].present?
      return false if actions[:except].include?(action)
    end

    if actions[:only].present?
      return false unless actions[:only].include?(action)
    end

    # return false if except.include?(action)
    # return true if only.include?(action)

    # return true if configs[role].include?(:All)
    # return true if configs[role].include?(:All)
    true
  end
end
