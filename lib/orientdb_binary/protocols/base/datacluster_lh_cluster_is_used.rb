module OrientdbBinary
  module BaseProtocol

    class DataclusterLhClusterIsUsed < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATACLUSTER_LH_CLUSTER_IS_USED
      int32 :session
    end

    class DataclusterLhClusterIsUsedAnswer < BinData::Record
      endian :big

      int32 :session
      bit4 :succeed
    end
  end
end
