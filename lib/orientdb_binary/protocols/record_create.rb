module OrientdbBinary
  module Protocols

    class RecordCreate < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_RECORD_CREATE
      int32 :session

      int32 :datasegment_id
      int16 :cluster_id
      protocol_string :record_content
      int8 :record_type
      int8 :mode
    end

    class RecordCreateAnswer < BinData::Record
      endian :big

      int32 :session
      int64 :cluster_position
      int32 :record_version

      def process(options)
        return {
          :@rid => "##{options[:cluster_id]}:#{cluster_position}",
          :@version => record_version,
          :@type => options[:record_type]
        }
      end
    end
  end
end
