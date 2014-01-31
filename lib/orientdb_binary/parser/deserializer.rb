module OrientdbBinary
  module Parser
    class Deserializer
      attr_accessor :record

      def initialize()
        @record = {}
      end

      # the code below comes from orientdb-node parser module
      # it needs to be tested, checked and refactored to be more Ruby

      def split(serialized, position)
        first = serialized[0...position]
        second = serialized[position+1..-1]
        return first, second
      end

      def deserialize_document(serialized, document={}, is_map=false)
        serialized = serialized.strip
        class_index = serialized.index('@')
        colon_index = serialized.index(':')
        if class_index && (!colon_index || colon_index > class_index)
          document[:@class], serialized = split(serialized, class_index)
        end
        document[:@type] = "d" unless is_map

        while (serialized and field_index = serialized.index(':')) do
          field, serialized = split(serialized, field_index)

          if field[0] == "\"" and field[-1] == "\""
            field = field[1..-2]
          end

          comma_index = look_for_comma_index(serialized)
          value, serialized = split(serialized, comma_index)
          value = deserialize_field_value(value)
          document[field.to_sym] = value
        end
        document
      end

      def deserialize_field_value(value)
        return nil if value.empty?

        if ["true", "false"].include? value
          return value == "true"
        end

        first_char = value[0]
        last_char = value[-1]

        if "\"" == first_char
          val = value[1..-2]
          val = val.gsub(/\\"/, "\"")
          val = val.sub(/\\\\/, "\\")
          return val
        end

        # split for date and datetime
        if ["t", "a"].include? last_char
          date = DateTime.strptime(value[0..-1],'%s')
          date = date.to_date if last_char == "a"
          return date
        end

        if "(" == first_char
          return deserialize_document(value[1..-2])
        end

        if "{" == first_char
          return deserialize_document(value[1..-2], {}, true)
        end

        if ["[", "<"].include? first_char
          ret = [] if first_char == "["
          ret = Set.new if first_char == "<"

          values = split_values_from(value[1..-2])
          values.each { |val| ret << deserialize_field_value(val) }
          return ret
        end

        if "b" == last_char
          return value[0..-1].to_i.chr
        end

        # split for long/short?
        if ["l", "s"].include? last_char
          return value[0..-2].to_i
        end

        if "c" == last_char
          return BigDecimal.new(value[0..-2].to_i)
        end

        if ["f", "d"].include? last_char
          return value[0..-2].to_f
        end

        return value.to_i if value.to_i.to_s == value

        return value
      end

      def split_values_from(value)
        result = []
        while value do
          comma_at = look_for_comma_index(value)
          res, value = split(value, comma_at)
          result << res
        end
        result
      end

      def look_for_comma_index(serialized)
        delimiters = []
        (0...serialized.length).each do |idx|
          current = serialized[idx]
          if current == "," and delimiters.length == 0
            return idx
          elsif start_delimiter?(current) and delimiters[-1] != "\""
            delimiters << current
          elsif end_delimiter?(current) and delimiters[-1] != "\"" and current == opposite_delimiter_of(delimiters[-1])
            delimiters.pop
          elsif current == "\"" and delimiters[-1] == "\"" and idx > 0 and serialized[idx-1] != "\\"
            delimiters.pop
          elsif current == "\"" and delimiters[-1] != "\""
            delimiters << current
          end
        end
        return serialized.length
      end

      def start_delimiter?(c)
        ["(", "[", "{", "<"].include? c
      end

      def end_delimiter?(c)
        [")", "]", "}", ">"].include? c
      end

      def opposite_delimiter_of(c)
        case c
        when "[" then return "]"
        when "{" then return "}"
        when "(" then return ")"
        when "<" then return ">"
        else return "\""
        end
      end
    end
  end
end
