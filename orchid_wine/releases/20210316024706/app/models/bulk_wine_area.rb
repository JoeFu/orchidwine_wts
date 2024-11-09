class BulkWineArea < ApplicationRecord

  def self.get(id)
    area = BulkWineArea.find_cache(id)
    return if area.blank?
    # [area.name_zh, ' (', area.name_en, ')'].join
    area.name_zh
  end

  def self.get_code(id)
    area = BulkWineArea.find_cache(id)
    return if area.blank?
    area.code
  end

  def self.options
    where(is_delete: 0).map do |area|
      [area.id, [area.name_zh, ' (', area.name_en, ')'].join]
    end.to_h
  end

  after_update do
    del_cache
    BulkWine.where(is_delete: 0).where('area_id_one = ? or area_id_two = ?', self.id, self.id).map do |bk|
      bk.update code: bk.init_code, desc: bk.init_desc
    end
  end
end
