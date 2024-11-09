class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # return symbol attributes hash
  def attrs
    attributes.symbolize_keys
  end

  def self.attrs
    attribute_names.map(&:to_sym)
  end

  def class_name_plz
    self.class.name.tableize
  end

  def self.status_hash
    {'全部' => nil, '启用' => 1, '禁用' => 0}
  end

  def created_human
    self.created_at.strftime('%Y-%m-%d %H:%M')
  end

  def updated_human
    self.updated_at.strftime('%Y-%m-%d %H:%M')
  end

  def self.find_cache(id)
    return nil if id.blank?
    return nil if id.to_i.zero?

    redis_key = [name, id].join(':')

    # 如果是来自redis的obj，则需要:
    # (1) 将@new_record 这个变量置为false
    # (2) 将@changed_attributes 这个变量清空
    # 防止update时将其视为create，造成update失败
    if (str = $redis.get(redis_key)).present?
      obj = new(JSON.parse(str).deep_symbolize_keys)
      obj.instance_variable_set(:@new_record, false)
      obj.instance_variable_set(:@changed_attributes, nil)
      obj
    else
      if (obj = find_by(id: id)).present?
        $redis.set(redis_key, obj.attrs.to_json)
        $redis.expire(redis_key, 60 * 60 * 24)
        obj
      end
    end
  end

  def del_cache
    redis_key = [self.class.name, id].join(':')
    $redis.del(redis_key)
  end

  after_save do
    del_cache
  end

  after_destroy do
    del_cache
  end
end
