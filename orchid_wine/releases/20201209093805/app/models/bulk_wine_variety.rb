class BulkWineVariety < ApplicationRecord

  def self.get(id)
    variety = BulkWineVariety.find_cache(id)
    return if variety.blank?
    # [variety.name_zh, ' (', variety.name_en, ')'].join
    variety.name_zh
  end

  def self.get_code(id)
    variety = BulkWineVariety.find_cache(id)
    return if variety.blank?
    variety.code
  end

  def self.codes
    where(is_delete: 0).pluck(:code)
  end


  def self.options
    where(is_delete: 0).map do |variety|
      [variety.id, [variety.name_zh, ' (', variety.name_en, ')'].join]
    end.to_h
  end

  after_update do
    del_cache
    BulkWine.where(is_delete: 0).where('variety_id_one = ? or variety_id_two = ? or variety_id_three = ?', self.id, self.id, self.id).map do |bk|
      bk.update code: bk.init_code, desc: bk.init_desc
    end
  end
end
