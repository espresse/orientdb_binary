module OrientdbBinary
  module BaseProtocol

    class DatasegmentAdd < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATASEGMENT_ADD
      int32 :session

      protocol_string :name
      protocol_string :location

    end

    class DatasegmentAddAnswer < BinData::Record
      endian :big

      int32 :session
      int32 :segment_id
    end
  end
end
