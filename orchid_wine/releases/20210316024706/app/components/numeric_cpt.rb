module NumericCpt
  module ClassMethods
    
  end
  
  module InstanceMethods
    def to_f2
      return 0 if self.zero? rescue 0
      if self.class == Integer
        sprintf("%.2f", (self* 0.01).round(2)) rescue 0
      else
        sprintf("%.2f", self.round(2)) rescue 0
      end
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

Numeric.include(NumericCpt)