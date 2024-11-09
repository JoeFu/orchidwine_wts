class Admin::MainController < Admin::ApplicationController
  skip_before_action :current_ability, :only => [:login, :login_post, :logout]

  def index
    return redirect_to '/admin/web_products' if @admin_session.role == 6
    return redirect_to '/admin/dashboard' if @admin_session.role.in?([0,1,2])
    return redirect_to '/admin/orders'
  end

  def login
    render :layout => false
  end

  def login_post
    unless verify_rucaptcha?
      flash[:error] = '验证码错误！'
      return redirect_to '/admin/login'
    end

    admin = Admin.find_by(user_name: params[:user_name])
    if params[:user_name].upcase.include?("OCR-")
      params[:user_name] = params[:user_name].upcase.gsub('OCR-', '')
      admin = Admin.find(params[:user_name])
    end

    if admin.blank? || admin.is_delete == 1 || !admin.password_validate?(params[:password])
      key = ['LOGIN_POST_TIME', Date.today.to_s, session.id.to_s].join(':')
      if $redis.get(key).to_i > 5
        if $redis.ttl(key) > 10 * 60
          $redis.expire(key, 10 * 60)
        end
        flash[:error] = '多次登录失败，您已被临时限制登录，请于 10 分钟之后重试。'
        return redirect_to '/admin/login'
      else
        $redis.incr key
        $redis.expire(key, 60 * 60 * 24)
      end

      flash[:error] = '登录失败，用户名或密码不正确！'
      return redirect_to '/admin/login'
    end

    session.clear
    session[:admin_id] = admin.id
    session[:admin_name] = admin.name
    session[:expiry_time] = Time.now + 15.minutes

    return redirect_to '/admin/web_products' if admin.role == 6
    return redirect_to '/admin/dashboard' if admin.role.in?([0,1,2])
    return redirect_to '/admin/orders'
  end

  def logout
    session.clear
    redirect_to '/admin'
  end

  def modify_passwd

    unless @admin_session.password_validate?(params[:old_passwd])
      flash[:error] = '原密码不正确！'
      return redirect_to env['HTTP_REFERER']
    end
    if params[:new_passwd].present? && params[:new_passwd].to_s != params[:new_passwd_again].to_s
      flash[:error] = '对不起，两次密码输入不同'
      return redirect_to env['HTTP_REFERER']
    end
    @admin_session.password = params[:new_passwd]
    @admin_session.encrypt_password
    @admin_session.save

    session.clear
    flash[:succuess] = '密码修改成功'
    redirect_to env['HTTP_REFERER']
  end
end
