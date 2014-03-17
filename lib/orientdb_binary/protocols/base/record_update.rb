module OrientdbBinary
  module BaseProtocol

    class RecordUpdate < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_RECORD_UPDATE
      int32 :session

      int16 :cluster_id
      int64 :cluster_position
      protocol_string :record_content
      int32 :record_version
      int8 :record_type
      int8 :mode
    end

    class RecordUpdateAnswer < BinData::Record
      endian :big

      int32 :session
      int32 :record_version
    end
  end
end
