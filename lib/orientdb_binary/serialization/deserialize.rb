module OrientdbBinary
  module Serialization
    class Deserialize
      def initialize()
        @record = {}
      end

      # the code below comes from orientdb-node parser module
      # it needs to be tested, checked and refactored to be more Ruby

      def deserialize_document(serialized, document={}, is_map=false)
        serialized = serialized.trim
        class_index = serialized.index('@')
        colon_index = serialized.index(':')
        if class_index && (!colon_index || colon_ndex > class_index)
          @record[:class] = serialized[0...class_index]
          serialized = serialized[class_index..-1]
        end

        @record["type"] = "d" unless is_map

        while (field_index = serialized.index(':') do
          field = serialized[0...field_index]
          serialized = serialized[field_index..-1]

          if field[0] == "\"" and field[-1] == "\""
            field = field[1..-2]
          end

          comma_index = look_for_comma_index(serialized)
          value = serialized[0...comma_index]
          serialized = serialized[comma_index..-1]
          value = deserialize_field_value(value)
          @record[field.to_sym] = value
        end
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
          val = val.sub(/\\"/g, "\"")
          val = val.sub(/\\\\/, "\\")
          return val
        end

        # split for date and datetime
        if ["t", "a"].include? last_char
          return Date.new(value[0..-1])
        end

        if "(" == first_char
          return deserialize_document(value[1..-1])
        end

        if "{" == first_char
          return deserialize_document(value[1..-2], {}, true)
        end

        # split for list and set
        if ["[", "<"].include? first_char
          ret = []
          values = split_values_from(value[1..-2])
          values.each do |val|
            ret.push deserialize_field_value(val)
          end
          return ret
        end

        if "b" == last_char
          return value[0..-1].to_i.chr
        end

        # split for long/short/byte
        if ["l", "s", "c"].include? last_char
          return value[0..-2].to_i
        end

        # split for float, big decimal
        if ["f", "d"].include? last_char
          return value[0..-2].to_f
        end

        return value.to_i if value.to_i.to_s == value

        return value
      end

      def split_values_from(value)
        result = []
        while value.length > 0
          comma_at = look_for_comma_index(value)
          result << value[0...comma_at]
          value = value[comma_at..-1]
        end
        result
      end

      def look_for_comma_index(serialized)
        delimiters = []
        (0...serialized.index).each do |idx|
          current = serialized[idx]
          if current == "," and delimiters.length == 0
            return idx
          elsif start_delimiter?(current) and delimiters[-1] != "\""
            delimiters << current
          elsif end_delimiter?(current) and delimiters[-1] != "\"" and current == opposite_delimiter_of(delimiters[-1])
            delimiters.pop
          elsif current == "\"" and delimiters[-1] == "\"" and idx > 0 and serialized[idx-1] != "\\"
            delimiters.pop
          elsif current === "\"" and delimiters[-1] !== "\""
            delimiters << current
          end              
        end
        return serialized.length
      end

      def start_delimiter?(c)
        ["(", "[", "{", "<"].includes? c
      end

      def end_delimiter?(c)
        [")", "]", "}", ">"].includes? c
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
