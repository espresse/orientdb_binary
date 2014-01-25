module OrientdbBinary
  module Serialization
    class Deserialize
      def initialize(record_content)
        @record_text = record_content
        @local = record_content
        @record = {params: {}}
      end

      def find_class
        reg = /([^,@]+)@/
        klass = @local.match reg
        if klass
          @local = @local.gsub(/^[^@]*@/, '')
          return klass[1]
        end
      end

      def parse_param(param)
        first_char = param[0]
        case first_char
        when "\""
          return param[1..-2]
        when "_"
          return (param[1..-2] == "true" ? true : false)
        when "#"
          return param[1..-1].split(':')
        else
          return nil
        end
      end

      def find_param(remain)
        parts = remain.split(',')
        if parts.length > 0
          _param = parts.shift
          param = _param.split(':')
          key = param.shift.to_sym
          @record[:params][key] = parse_param(param.join(':'))
          find_param(parts.join(','))
        end
        remain
      end

      def deserialize
        @record[:class] = find_class
        find_param(@local)
        p @record
        @record_text
      end
    end
  end
end
