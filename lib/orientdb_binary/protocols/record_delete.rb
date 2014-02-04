module OrientdbBinary
  module Protocols

    class RecordDelete < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_RECORD_DELETE
      int32 :session

      int16 :cluster_id
      int64 :cluster_position
      int32 :record_version
      int8 :mode
    end

    class RecordDeleteAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :payload_status
    end
  end
end
