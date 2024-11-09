class BulkWineSort < ApplicationRecord

  def self.get(id)
    sort = BulkWineSort.find_cache(id)
    return if sort.blank?
    # [sort.name_zh, ' (', sort.name_en, ')'].join
    sort.name_zh
  end

  def self.get_code(id)
    sort = BulkWineSort.find_cache(id)
    return if sort.blank?
    sort.code
  end

  def self.options
    where(is_delete: 0).map do |area|
      [area.id, [area.name_zh, ' (', area.name_en, ')'].join]
    end.to_h
  end

  after_update do
    del_cache
    BulkWine.where(is_delete: 0, sort_id: self.id).map do |bk|
      bk.update code: bk.init_code, desc: bk.init_desc
    end
  end
end
