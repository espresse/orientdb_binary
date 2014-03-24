module OrientdbBinary
  module BaseProtocol

    class DbOpen < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_OPEN
      int32 :session, value: OrientdbBinary::OperationTypes::NEW_SESSION

      protocol_string :driver_name, value: OrientdbBinary::NAME
      protocol_string :driver_version, value: OrientdbBinary::VERSION
      int16 :protocol, value: OrientdbBinary::CURRENT_PROTOCOL_VERSION
      protocol_string :client_id
      protocol_string :name
      protocol_string :storage
      protocol_string :user
      protocol_string :password
    end

    class DbOpenAnswer < BinData::Record
      endian :big

      skip length: 4
      int32 :session
      int16 :num_of_clusters
      array :clusters, initial_length: :num_of_clusters do
        protocol_string :name
        int16 :cluster_id
        protocol_string :cluster_type
        int16 :segment_id
      end
      int32 :cluster_config_bytes
      skip length: :cluster_config_bytes, onlyif: :has_cluster_config?
      protocol_string :orientdb_release

      def has_cluster_config?
        cluster_config_bytes > -1
      end
    end
  end
end
