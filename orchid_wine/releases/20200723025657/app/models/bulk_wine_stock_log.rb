# encoding: utf-8
# 库存日志
class BulkWineStockLog < ApplicationRecord

  belongs_to :bulk_wine
  belongs_to :admin

end
