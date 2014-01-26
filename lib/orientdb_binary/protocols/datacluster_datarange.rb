module OrientdbBinary
  module Protocols

    class DataclusterDatarange < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATACLUSTER_DATARANGE
      int32 :session

      int16 :cluster_id
    end

    class DataclusterDatarangeAnswer < BinData::Record
      endian :big

      int32 :session
      int64 :record_id_begin
      int64 :record_id_end
    end
  end
end
