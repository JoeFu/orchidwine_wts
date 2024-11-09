# encoding: utf-8
module StringCpts
  CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  module ClassMethods
    def sample(n = 1, sort = 0)
      str = ''
      1.upto(n) { str << CHARS.sample }

      case sort
      when 1
        str.upcase
      when -1
        str.downcase
      else
        str
      end
    end

    def sample_no(n = 1)
      str = ('1'..'9').to_a.sample
      str + (n - 1).times.map { ('0'..'9').to_a.sample }.compact.join
    end

    alias :random :sample
  end

  module InstanceMethods

    def to_f2_i
      (self.to_f * 100).to_i
    end

    def load
      result = JSON.parse(self) rescue {}

      case result
      when Array
        result.map do |r|
          case r
          when Hash
            r.deep_symbolize_keys
          else
            r
          end
        end
      when Hash
        result.deep_symbolize_keys
      else
        result
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
String.include(StringCpts)