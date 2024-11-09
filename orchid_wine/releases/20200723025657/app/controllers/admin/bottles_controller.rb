class Admin::BottlesController < Admin::ApplicationController
  before_action :find_model

  include UploadHelper

  def index
    conditions, values = [], []
    if params[:bottle_code].present?
      conditions << 'bottle_code = ?'
      values << params[:bottle_code].upcase
    end

    if params[:status].present?
      conditions << 'status = ?'
      values << params[:status]
    end

    conditions << 'is_delete = 0'

    @bottles = Bottle.where(conditions.join(' and '), *values)
    .order('status desc, id desc')
    .limit(Const::ADMIN_PAGE_SIZE)
    .page(params[:page])
  end

  def create
    {
      :cover => '请上传缩略图',
      :bottle_code => '请选择瓶型',
      :vendor_code => '请填写供应商编码',
      :height => '请填写瓶高',
      :volume => '请填写容量',
      :weight => '请填写重量',
      :shape => '请填写瓶形状',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/bottles/new'
      end
    end
    params[:height] = float_int(params[:height])
    params[:volume] = float_int(params[:volume])
    params[:weight] = float_int(params[:weight])

    params[:bottle] = params
    bottle = Bottle.create params.require(:bottle).permit(*Bottle.attrs)

    flash[:success] = '酒瓶添加成功！'
    redirect_to session[:list_url]
  end

  def update
    if @bottle.blank?
      flash[:error] = '不存在该酒瓶'
      return redirect_to '/admin/bottles'
    end

    {
      :cover => '请上传缩略图',
      :bottle_code => '请选择瓶型',
      :vendor_code => '请填写供应商编码',
      :height => '请填写瓶高',
      :volume => '请填写容量',
      :weight => '请填写重量',
      :shape => '请填写瓶形状',
    }.map do |k,v|
      if params[k].blank?
        flash[:error] = v
        return render '/admin/bottles/edit'
      end
    end
    params[:height] = params[:height].to_f2_i
    params[:volume] = params[:volume].to_f2_i
    params[:weight] = params[:weight].to_f2_i

    params[:bottle] = params
    @bottle.update params.require(:bottle).permit(*Bottle.attrs)
    flash[:success] = '编辑成功'
    redirect_to session[:list_url]
  end

  def destroy
    @bottle.update :is_delete => 1
    flash[:success] = '酒瓶删除成功！'
    redirect_to session[:list_url]
  end

  def select_options
    bottle_options = []
    bottle_options = Bottle.select_options(params[:type], nil, params[:package])
    if bottle_options.blank?
      bottle_options << "<option value=''>暂无酒瓶可选</option>"
    end

    divider_options = Divider.select_options(params[:package])
    carton_options = Carton.select_options(params[:package])

    render :json => {
      code: 1,
      bottle_options: bottle_options,
      divider_options: divider_options,
      carton_options: carton_options,
    }
  end

  def status
    @bottle.update :status => @bottle.status ^ 1
    flash[:success] = "酒瓶#{@bottle.status.zero? ? '下架' : '上架'}操作成功！"
    redirect_to session[:list_url]
  end

  def export
    rows = [
      ['型号', '供应商代码', '单价', '封瓶方式', '容量（ml）', '瓶形状', '状态']
    ]
    Bottle.all.order('status desc, id desc')
    .map do |bottle|
      row = []
      row << bottle.bottle_code
      row << bottle.vendor_code
      row << bottle.price
      row << bottle.show_seal
      row << int_float(bottle.volume)
      row << bottle.shape
      row << (bottle.status == 1 ? '已上架' : '无服务费')
      rows << row
    end
    file_name = "TWS-Bottle-#{Time.now.strftime('%Y%m%d%H%M')}"
    write_xlsx(rows, file_name, :string)
    send_file "#{Const::UPLOAD_EXCEL}/#{file_name}.xlsx"
  end

  private
  def find_model
    @bottle = Bottle.find(params[:id]) if params[:id]
  end
end
