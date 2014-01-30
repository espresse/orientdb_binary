module OrientdbBinary
  module Serialization
    class Serialize
      def initialize()
      end

      def serialize_field_value(value)

        if value.is_a? String
          val = /^#\-{0,1}[\d]+:\-{0,1}[\d]+$/.match(value)
          return value if val
          value = value.sub(/\\/, "\\\\")
          value = value.gsub(/"/, "\\\"")
          return "\"#{value}\""
        end

        if value.is_a? Integer
          return value.to_s
        end

        if value.is_a? Float
          return value.to_s + "f"
        end

        if value.is_a? Bignum
          return value.to_s + "l"
        end

        if value.is_a? BigDecimal
          return value.to_s + "d"
        end

        if value.is_a? Array or value.is_a? Set
          type = value.class.to_s.downcase == "set" ? "<$>" : "[$]"
          result = []

          value.each do |el|
            result << serialize_field_value(el)
          end
          return type.gsub("$", result.join(','))
        end

        if value.is_a?(TrueClass) or value.is_a?(FalseClass)
          return value.to_s
        end

        if value.is_a? Hash
          type = value[:@type] == "d" ? "($)" : "{$}"
          return type.gsub("$", serialize_document(value, value[:@type] != "d"))
        end

        if value.is_a? Date
          value.to_datetime.to_time.to_i + "a"
        end

        if value.is_a? DateTime
          value.to_time.to_i + "t"
        end

        if value.is_a? Time
          value.to_i + "t"
        end
      end

      def serialize_document(document, is_map=false)
        klass = ""
        result = []
        document.each do |key, value|
          unless [:@version, :@rid, :@type].include? key
            if key == :@class
              klass = value
            else
              field_wrap = is_map ? "\"" : ""
              result << "#{key.to_s}:#{serialize_field_value(value)}"
            end
          end
        end
        return klass.empty? ? result.join(',') : klass + "@" + result.join(',')
      end
    end
  end
end

