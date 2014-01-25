module OrientdbBinary
  module Protocols

    class RecordContent < BinData::Primitive
      endian :big
      protocol_string :content

      def get
        self.content = OrientdbBinary::Serialization::Deserialize.new(self.content).deserialize
      end

      def set(v)
        content = v
      end
    end

    class RecordLoad < BinData::Record
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_RECORD_LOAD
      int32 :session

      int16 :cluster_id
      int64 :cluster_position
      protocol_string :fetch_plan
      int8 :ignore_cache
      int8 :load_tombstones
    end

    class RecordLoadAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :payload_status
      array :rec, initial_length: :payload_status do
        record_content :record_content
        int32 :record_version
        record_type :record_type
      end
    end
  end
end
