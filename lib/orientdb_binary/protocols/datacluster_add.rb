Request:  (type:string)(name:string)(location:string)(datasegment-name:string)(cluster-id:short - since 1.6 snapshot)
Response: (new-cluster:short)

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
      int8 :cluster_id, initial_value: -1
    end

    class DataclusterAddAnswer < BinData::Record
      endian :big

      int8 :cluster_id
    end
  end
end
