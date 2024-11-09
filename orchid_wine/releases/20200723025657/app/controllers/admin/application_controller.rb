class Admin::ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  # helper :all
  include MethodsHelper
  include Admin::AuthorityHelper

  before_action :current_ability
  layout 'admin'

  def current_ability
    @admin_session = Admin.find_by_id(session[:admin_id])
    if @admin_session.blank?
      return redirect_to "/admin/login"
    end
    session[:expiry_time] = Time.now + 6.hours

    @action = params[:action].to_sym
    @controller = params[:controller].split('/').last.singularize.classify.to_sym
    
    unless can?(@action, @controller)
      return redirect_to '/403.html'
    end

    if @action == :index && @controller != :OrdersNew
      session[:list_url] = request.original_fullpath
    end
  end
end
