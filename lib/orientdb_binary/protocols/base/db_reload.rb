module OrientdbBinary
  module BaseProtocol

    class DbReload < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_RELOAD
      int32 :session
    end

    class DbReloadAnswer < BinData::Record
      endian :big

      int32 :session
      int16 :num_of_clusters
      array :clusters, initial_length: :num_of_clusters do
        protocol_string :name
        int16 :cluster_id
        protocol_string :cluster_type
        int16 :segment_id
      end
    end
  end
end
