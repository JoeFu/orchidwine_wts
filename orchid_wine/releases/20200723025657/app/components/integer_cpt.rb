module IntegerCpt
  module ClassMethods
    
  end
  
  module InstanceMethods
    def ts
      f = self < 0
      s = self.abs.to_s
      length = s.size
      r = length.times.map do |i|
        j = length - i - 1
        ((i+1) % 3 == 0 && i+1 != length) ? ',' + s[j] : s[j]
      end.reverse.join

      f ? '-' + r : r
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

Integer.include(IntegerCpt)
