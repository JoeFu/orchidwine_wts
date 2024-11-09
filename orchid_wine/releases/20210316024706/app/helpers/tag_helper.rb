# encoding: utf-8
module TagHelper
  # 表格footer，包含will_paginate翻页
  def table_footer_tag(objects)
    html = <<-HTML
    <div class="col-sm-5">
    <div class="dataTables_info">
    %s
    </div>
    </div>

    <div class="col-sm-7">
    %s
    </div>
    HTML

    html % [page_entries_info(objects), will_paginate(objects)]
  end

  def frontend_page_tag(objects)
    html = <<-HTML
    <div class='frontend_paginate'>%s</div>
    HTML

    html % [will_paginate(objects)]
  end

  # =========================================
  def status_label_tag(obj, args = {})
    args[:texts] = {0 =>'已禁用', 1 =>'已启用'} if args[:texts].blank?
    args[:colors] = {0 => "warning", 1 =>"success"} if args[:colors].blank?

    html = <<-HTML
    <span class="label label-%s">%s</span>
    HTML
    return html % [args[:colors][obj.status], args[:texts][obj.status]]
  end

  def status_btn_tag(obj, args = {})
    args[:texts] = {0 =>'启用', 1 =>'禁用'} if args[:texts].blank?
    args[:colors] = {0 => "success", 1 =>"warning"} if args[:colors].blank?
    args[:icons] = {0 => "ion-checkmark-circled", 1 =>'ion-close-circled'} if args[:icons].blank?

    url = "/admin/%s/%d/status" % [obj.class_name_plz ,obj.id]

    color = args[:colors][obj.status]
    text = args[:texts][obj.status]
    i = args[:icons][obj.status]

    i = '<i class="btn-label ' + i + '"></i>' if i.present?
    html = <<-HTML
    <a href="%s" class="mtd-patch btn btn-sm btn-labeled btn-rounded btn-%s">%s %s</a>
    HTML
    return html % [url, color, i, text]
  end

  def destroy_btn_tag(obj)
    i = '<i class="btn-label ion-trash-b"></i>'
    url = "/admin/%s/%d" % [obj.class_name_plz, obj.id]

    html = <<-HTML
    <a href="%s" class="mtd-delete btn btn-sm btn-labeled btn-rounded btn-danger">%s %s</a>
    HTML
    return html % [url, i, '删除']
  end


  def new_btn_tag(url, text='添加')
    html = <<-HTML
    <a href='%s' class="btn btn-sm btn-labeled btn-rounded btn-purple ">
    <i class="btn-label ion-plus-circled"></i> %s
    </a>
    HTML
    return html % [url, text]
  end

  def edit_btn_tag(obj, text = '编辑', url = nil)
    i = '<i class="btn-label ion-edit"></i>'
    if url.blank?
      url = "/admin/%s/%d/edit" % [obj.class_name_plz ,obj.id]
    end

    html = <<-HTML
    <a href="%s" class="btn btn-sm btn-labeled btn-rounded btn-primary">%s %s</a>
    HTML
    return html % [url, i, text]
  end

  def show_btn_tag(obj,url = nil, text = nil)
    i = '<i class="btn-label ion-information-circled"></i>'
    url = "/admin/%s/%d" % [obj.class_name_plz ,obj.id] if url.blank?
    text = '详情' if text.blank?

    html = <<-HTML
    <a href="%s" class="btn btn-sm btn-labeled btn-rounded btn-default">%s %s</a>
    HTML
    return html % [url, i, text]
  end

  def show_link(obj)
    url = "/admin/%s/%d" % [obj.class_name_plz ,obj.id] if url.blank?
    html = <<-HTML
    <a href="%s" class="btn-link">%s</a>
    HTML
    return html % [url, obj.name]
  end

  def export_btn_tag(url, text='导出')
    html = <<-HTML
    <a href='%s' class="btn btn-sm btn-labeled btn-rounded btn-primary">
    <i class="btn-label ion-archive"></i> %s
    </a>
    HTML
    return html % [url, text]
  end

  # =========================================

  def a_get_tag(text=nil, url='#', color='primary', i=nil)
    i = '<i class="btn-label ' + i + '"></i>' if i.present?
    html = <<-HTML
    <a href="%s" class="btn btn-sm btn-labeled btn-rounded btn-%s">%s %s</a>
    HTML
    return html % [url, color, i, text]
  end

  def a_put_tag(text=nil, url='#', color='primary', i=nil)
    i = '<i class="btn-label ' + i + '"></i>' if i.present?
    html = <<-HTML
    <a href="%s" class="mtd-put btn btn-sm btn-rounded btn-labeled btn-%s">%s %s</a>
    HTML
    return html % [url, color, i, text]
  end

  def a_patch_tag(text=nil, url='#', color='primary', i=nil)
    i = '<i class="btn-label ' + i + '"></i>' if i.present?
    html = <<-HTML
    <a href="%s" class="mtd-patch btn btn-sm btn-rounded btn-labeled btn-%s">%s %s</a>
    HTML
    return html % [url, color, i, text]
  end


  # =========================================

  def submit_tag(text = '搜索')
    html = <<-HTML
    <button class="btn btn-primary"><i class="ion-search"></i> 搜索</button>
    HTML
    return html % text
  end

  def clear_tag(url, text = '清空条件')
    html = <<-HTML
    <a href="%s" class="btn btn-default"> %s</a>
    HTML
    return html % [url, text]
  end

  def return_list_tag(text = '返回列表')
    html = <<-HTML
    <a href='%s' class="btn btn-icon btn-primary">
    <i class="ion-arrow-left-c"></i> %s
    </a>
    HTML
    return html % [session[:list_url], text]
  end

  # =========================================

  def submit_save(text = '保存')
    html = <<-HTML
    <button class="btn btn-success btn-labeled" type='submit'><i class="btn-label ion-archive"></i> %s</button>
    HTML
    return html % text
  end
end
