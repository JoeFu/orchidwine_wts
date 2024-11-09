# encoding: utf-8
# 供应商
class BulkWineVendor < ApplicationRecord

  has_many :bulk_wines, :foreign_key => "vendor_id"

  # string vendor_code
  # string name
  # string address
  # string telphone
  # integer :is_delete 状态：0 - 没，1 - 删除

  def self.options
    self.where(:is_delete => 0).map do |vendor|
      [vendor.id, [vendor.vendor_code, vendor.name].join(' - ')]
    end.to_h
  end

  def code_name
    [vendor_code, name].join(' - ')
  end


  after_update do
    BulkWine.where(is_delete: 0, vendor_id: self.id).map do |bk|
      bk.update code: bk.init_code, desc: bk.init_desc
    end
  end
end
