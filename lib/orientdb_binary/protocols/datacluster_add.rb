module OrientdbBinary
  module Protocols

    class DataclusterAdd < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATACLUSTER_ADD
      int32 :session

      protocol_string :cluster_type
      protocol_string :name
      protocol_string :location
      protocol_string :datasegment_name
      int16 :cluster_id, value: -1
    end

    class DataclusterAddAnswer < BinData::Record
      endian :big

      int32 :session
      int16 :cluster_id
    end
  end
end
