module OrientdbBinary
  module BaseProtocol

    class DatasegmentDrop < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATASEGMENT_DROP
      int32 :session

      protocol_string :name

    end

    class DatasegmentDropAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :succeed
    end
  end
end
