module FloatCpts
  module ClassMethods
    
  end
  
  module InstanceMethods
    def ts
      f = self < 0
      s = self.abs.to_s

      refs = s.to_s.split('.')
      s = refs[0]

      length = s.size
      r = length.times.map do |i|
        j = length - i - 1
        ((i+1) % 3 == 0 && i+1 != length) ? ',' + s[j] : s[j]
      end.reverse.join

      s = f ? '-' + r : r
      [s, refs[1][0..1]].join('.')
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end

Float.include(FloatCpts)
