module OrientdbBinary
  module BinDataPrimitives
    class ProtocolString < BinData::Primitive
      endian :big

      int32 :len, value: -> { data.length }
      string :data, read_length: :len

      def get
        data
      end

      def set(v)
        self.data = v
      end
    end

    class RecordType < BinData::Primitive
      endian :big

      int8 :type

      def get
        type.chr
      end

      def set(v)
        self.type = v.ord
      end
    end

    class RecordObject < BinData::Primitive
      endian :big

      protocol_string :content

      def get
        self.content = OrientdbBinary::Parser::Deserializer.new.deserialize_document(self.content)
      end

      def set(v)
        self.content = v
      end
    end
  end
end
