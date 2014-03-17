module OrientdbBinary
  module BaseProtocol

    class DataclusterDrop < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATACLUSTER_DROP
      int32 :session

      int16 :cluster_id
    end

    class DataclusterDropAnswer < BinData::Record
      endian :big

      int32 :session
      bit4 :succeed
    end
  end
end
