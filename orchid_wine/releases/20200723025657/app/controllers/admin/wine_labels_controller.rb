class Admin::WineLabelsController < Admin::ApplicationController
  before_action :find_model

  def index
    conditions, values = [], []
    if params[:q].present?
      user_ids = User.where("name like '%#{params[:q]}%'").pluck('id')
      p user_ids
      conditions << 'operate_id in (?)'
      values << user_ids
      conditions  << 'operate_rank = 2'
    else
      conditions << 'operate_rank = 1'
    end
    conditions << 'is_delete = 0'

    @wine_labels = WineLabel.where(conditions.join(' and '), *values)
    .preload(:production)
    .order('id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      :label_code => '请填酒标编号',
      :label_name => '请填写酒标名称',
      :front_label => '请上传前标',
      :behind_label => '请上传后标',
      :chinese_back_label => '请选择是否有中文背标',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render'/admin/wine_labels/new'
      end
    end

    params[:operate_id] = @admin_session.id #创建者ID
    params[:operate_rank] = 1 #创建者身份 1-管理员 2-客户

    params[:wine_label] = params
    wine_label = WineLabel.create params.require(:wine_label).permit(*WineLabel.attrs)
    flash[:success] = '酒标添加成功！'
    redirect_to session[:list_url]
  end

  def update
    wine_label = WineLabel[params[:id]]
    if wine_label.blank?
      flash[:error] = '不存在该酒标'
      return redirect_to '/admin/wine_labels'
    end

    {
      :label_code => '请填酒标编号',
      :label_name => '请填写酒标名称',
      :front_label => '请上传前标',
      :behind_label => '请上传后标',
      :chinese_back_label => '请选择是否有中文背标',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return redirect_to "/admin/wine_labels/#{wine_label.id}/edit"
      end
    end

    params[:wine_label] = params
    wine_label.update params.require(:wine_label).permit(*WineLabel.attrs)
    flash[:success] = '编辑成功'
    if wine_label.operate_rank == 1
      return redirect_to '/admin/wine_labels'
    else
      return redirect_to '/admin/wine_labels?user_name=' + (User[wine_label.operate_id].name rescue '')
    end
  end

  def fill
    @wine_label = WineLabel[params[:wine_label_id]]
    if @wine_label.blank?
      flash[:error] = '参数异常'
      return redirect_to '/admin/wine_labels?user_name=' +params[:user_name]
    end
  end

  #补全酒标
  def fill_wine_label
    wine_label = WineLabel[params[:wine_label_id]]
    if wine_label.blank?
      flash[:error] = '参数异常'
      return redirect_to '/admin/wine_labels'
    end
    {
      :label_code => '请填写酒标编码',
      :label_name => '请填写酒标名称',
      :front_label => '请上传前标',
      :behind_label => '请上传后标',
    }.map do |k,v|
      if params[k].blank?
        return redirect "/admin/wine_label/#{wine_label.id}/fill"
      end
    end
    # 更新wine_label表
    params[:wine_label] = params
    wine_label.update params.require(:wine_label).permit(*WineLabel.attrs)
    #更新用了此酒标的所有产品
    pro_arg = {
      :label_name => params[:label_name],
      :wine_front_img => params[:front_label],
      :wine_behind_img => params[:behind_label],
      :chinese_label => params[:chinese_back_label]
    }
    productions = Production.where(:wine_label_id => wine_label.id.to_i)
    productions.map do |pro|
      pro.update pro_arg
    end
    flash[:success] = '补全成功'
    if wine_label.operate_rank == 1
      return redirect_to '/admin/wine_labels'
    else
      return redirect_to '/admin/wine_labels?user_name=' + (User[wine_label.operate_id].name rescue '')
    end
  end

  # 创建产品的时候新建酒标
  def ajax_create_wine_label
    if @admin_session.blank?
      return_hash = {
        :code => 1,
        :message => '登录过期，请重新登录'
      }
    else
      params[:operate_id] = params[:user_id].to_i
      params[:operate_rank] = 1
      params[:label_code] = WineLabel.label_code_for_user(params[:user_id].to_i)
      if params[:label_name].blank?
        return_hash = {
          :code => 1,
          :message => '参数异常，请稍微重试'
        }
      else
        params[:wine_label] = params
        wine_label = WineLabel.create params.require(:wine_label).permit(*WineLabel.attrs)
        if wine_label.present?
          front_label = wine_label.front_label.present? ? wine_label.front_label : '/img/default_front_label.png'
          behind_label = wine_label.behind_label.present? ? wine_label.behind_label : '/img/default_behind_label.png'
          return_hash = {
            :code => 0,
            :data => {:label_id => wine_label.id,:label_name => wine_label.label_name,:front_img_url => front_label,:behind_img_url => behind_label,:label_code => wine_label.label_code,:chinese_back_label => wine_label.chinese_label_show}
          }
        else
          return_hash = {
            :code => 1,
            :message => '网络异常，请稍微重试'
          }
        end
      end
    end
    return render :json => return_hash.to_json
  end


  def destroy
    @wine_label.update :is_delete => 1
    flash[:success] = '酒帽颜色删除成功！'
    redirect_to session[:list_url]
  end

  private
  def find_model
    @wine_label = WineLabel.find(params[:id]) if params[:id]
  end
end
