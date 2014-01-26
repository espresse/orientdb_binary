module OrientdbBinary
  module Protocols

    class DatasegmentDrop < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATASEGMENT_DROP
      int32 :session

      protocol_string :name

    end

    class DatasegmentDropAnswer < BinData::Record
      endian :big

      int32 :session
      bit4 :succeed
    end
  end
end
