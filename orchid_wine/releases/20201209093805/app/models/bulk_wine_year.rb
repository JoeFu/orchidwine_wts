class BulkWineYear < ApplicationRecord

  def self.options
    where(is_delete: 0).pluck(:year).sort.reverse
  end
end
