module OrientdbBinary
  module Serialization
    class Serialize
      def initialize()
      end

      def serialize_field_value(value)
        result = ""
        if value.is_a? String
          return value if /^#\-{0,1}[\d]+:\-{0,1}[\d]+$/.match(value)
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
          type = value[:type] == "d" ? "($)" : "{$}"
          return type.gsub("$", serialize_document(value, value[:type] != "d"))
        end

        if value.is_a? Date
        end

        if value.is_a? DateTime
        end

        if value.is_a? Time
        end
      end

      def serialize_document(document, is_map)
        klass = "@"
        result = []
        document.each do |key, value|
          unless [:version, :rid, :type].include? key
            if key == :class
              klass = value + "@"
            else
              field_wrap = is_map ? "\"" : ""
            end
            result << "#{field_wrap}#{key.to_s}#{field_wrap}:#{serialize_field_value(value)}"
          end
        end

        return klass + "@" + result.join(',')
      end
    end
  end
end
