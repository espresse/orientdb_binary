module OrientdbBinary
  module Protocols

    class DataclusterCount < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DATACLUSTER_COUNT
      int32 :session

      int16 :cluster_count
      array :clusters, initial_length: :cluster_count do
        int16 :cluster_number
      end
      int8 :count_tombstones
    end

    class DataclusterCountAnswer < BinData::Record
      endian :big

      int32 :session
      int64 :records_in_clusters
    end
  end
end
