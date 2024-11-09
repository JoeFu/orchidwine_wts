module NilCpt
  module ClassMethods
    
  end
  
  module InstanceMethods
    def to_f2
      0
    end

    def ts
      0
    end

    def to_md
    end

    def to_ymd
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

NilClass.include(NilCpt)