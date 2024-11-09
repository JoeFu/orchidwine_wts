module TimeCpts
  module ClassMethods
    
  end
  
  module InstanceMethods
    def to_md
      self.strftime('%m/%d')
    end

    def to_ymd
      self.strftime('%Y/%m/%d')
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
Time.include(TimeCpts)
