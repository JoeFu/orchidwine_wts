RuCaptcha.configure do
  # Color style, default: :colorful, allows: [:colorful, :black_white]
  # self.style = :colorful
  # Custom captcha code expire time if you need, default: 2 minutes
  # self.expires_in = 120
  # [Requirement/重要]
  # Store Captcha code where, this config more like Rails config.cache_store
  # default: Read config info from `Rails.application.config.cache_store`
  # But RuCaptcha requirements cache_store not in [:null_store, :memory_store, :file_store]
  # 默認：會從 Rails 配置的 cache_store 裡面讀取相同的配置信息，用於存儲驗證碼字符
  # 但如果是 [:null_store, :memory_store, :file_store] 之類的，你可以通過下面的配置項單獨給 RuCaptcha 配置 cache_store
  self.cache_store = :redis_store, REDIS_SERVERS[Rails.env]
end