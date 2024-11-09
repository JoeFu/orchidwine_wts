# encoding: utf-8
class BulkWine < ApplicationRecord

  belongs_to :vendor, :class_name => 'BulkWineVendor'
  belongs_to :sort, :class_name => 'BulkWineSort'

  has_one :stock, :class_name => 'BulkWineStock'
  has_many :stock_logs, :class_name => 'BulkWineStockLog'
  has_many :order_productions

  # integer :status 状态：0 - 下架，1 - 上架
  # integer :is_delete 状态：0 - 没，1 - 删除

  STATUS = {
    0 => "下架",
    1 => "上架",
  }

  BATCHS = [1, 2, 3, 4, 5, "C", "D", "E", "F", "G"]

  def self.select_options(bulk_wine = nil)
    options = []
    bulk_wines = BulkWine.where(:is_delete => 0, :status => 1)
    if bulk_wine.present?
      bulk_wines = bulk_wines.where(:year => bulk_wine.year)
      .where('variety_id_one = ? or variety_id_two = ?',
             bulk_wine.variety_id_one,
             bulk_wine.variety_id_one)
    end

    bulk_wines.order('year asc, vendor_id asc, variety_id_one asc')
    .map do |bw|
      html = <<-HTML
      <option value="%s" data-price="%s" %s>%s</option>
      HTML

      selected = nil
      selected = 'selected="selected"' if bulk_wine.present? && bulk_wine.id == bw.id
      options << html % [bw.code, bw.price, selected, bw.desc]
    end
    options
  end

  def self.code_options
    BulkWine.where(:is_delete => 0, :status => 1).pluck(:id, :code).to_h
  end

  def status_show
    color = status.zero? ? "warning" : "success"

    html = <<-HTML
    <span class="label label-%s"> %s</span>
    HTML
    return html % [color, BulkWine::STATUS[status]]
  end

  def self.used_years
    self.where(:status => 1, :is_delete => 0).pluck(:year).uniq.sort.reverse
  end

  def areas_show
    return BulkWineArea.get(area_id_one) if area_id_one == area_id_two
    [BulkWineArea.get(area_id_one), BulkWineArea.get(area_id_two)].join('<br/>')
  end

  def varieties_show
    if variety_id_one == variety_id_two && variety_id_two == variety_id_three
      return BulkWineVariety.get(variety_id_one)
    end

    if variety_id_one != variety_id_two && variety_id_two == variety_id_three
      return [BulkWineVariety.get(variety_id_one), BulkWineVariety.get(variety_id_two)].join('<br/>')
    end

    [
      BulkWineVariety.get(variety_id_one),
      BulkWineVariety.get(variety_id_two),
      BulkWineVariety.get(variety_id_three)
    ].join('<br/>')
  end

  def export_name
    [(vendor.vendor_code rescue nil), year, areas_show.gsub('<br/>', ''), varieties_show.gsub('<br/>', '')].join
  end

  def year_show
    return "NV" if self.year.to_i == 2000
    self.year.to_s + "年" rescue "NV"
  end

  def sort_show
    BulkWineSort.get(sort_id)
  end

  def init_desc
    areas = [BulkWineArea.get(area_id_one)]
    if area_id_one != area_id_two
      areas << BulkWineArea.get(area_id_two)
    end

    varieties = [BulkWineVariety.get(variety_id_one)]
    if variety_id_one != variety_id_two
      varieties << BulkWineVariety.get(variety_id_two)
    end
    if variety_id_two != variety_id_three
      varieties << BulkWineVariety.get(variety_id_three)
    end

    [
      vendor_name,
      year,
      areas.join(" "),
      [varieties.join(" "), "(#{BulkWineSort.get(sort_id)})"].join,
      "第#{batch}批次"
    ].join(" ")
  end

  def init_code
    codes = [vendor.vendor_code, year]
    areas = [BulkWineArea.get_code(area_id_one)]
    if area_id_one != area_id_two
      areas << BulkWineArea.get_code(area_id_two)
    end
    codes << areas.join

    varieties = [BulkWineVariety.get_code(variety_id_one)]
    if variety_id_one != variety_id_two
      varieties << BulkWineVariety.get_code(variety_id_two)
    end
    if variety_id_two != variety_id_three
      varieties << BulkWineVariety.get_code(variety_id_three)
    end
    codes << varieties.join

    codes << BulkWineSort.get_code(sort_id)
    codes << batch
    codes.join('-')
  end

  after_create do
    if self.stock.blank?
      BulkWineStock.create :id => self.id, :bulk_wine_id => self.id
    end
  end

  def self.update_all_desc
    where(is_delete: 0).map do |bk|
      bk.update code: bk.init_code, desc: bk.init_desc
    end
  end

  # def self.clear_multi
  #   codes = ['PJW-2016-SA-SHZ-BK-1','KST-2015-SA-SHZ-BK-1','BVE-2012-BV-SHZ-BK-1','DAG-2013-MV-GRENACHESHZMOUVEDRE-BK-1','BKC-2015-EV-SHZ-CS-C','PJW-2016-LHCMV-SHZPV-BK-1','PTT-2000-NV-Dry_Red-BK-1','PJW-2017-SA-Chardonnay-BK-1','FV-2016-SA-CAB-BK-1','CJW-2012-LC-CAB-BK-1','PTT-2000-NV-Dry_White-BK-1']

  #   # p self.where(code: codes, status: 0).size
  #   # p self.where(code: codes, status: 1).size

  #   arrs = []
  #   self.where(code:codes).order(:code).map do |bw|
  #    arrs << [bw.id,  bw.stock.total_stock, bw.stock.sold_count, bw.stock.stock, bw.status, bw.code, bw.order_productions.size]
  #   end
  #   pp arrs
  #   nil
  # end
end
