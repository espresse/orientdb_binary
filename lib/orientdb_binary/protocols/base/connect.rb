module OrientdbBinary
  module BaseProtocol
    class Connect < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONNECT
      int32 :session, value: OrientdbBinary::OperationTypes::NEW_SESSION

      protocol_string :driver, value: OrientdbBinary::NAME
      protocol_string :driver_version, value: OrientdbBinary::VERSION
      int16 :protocol, value: OrientdbBinary::CURRENT_PROTOCOL_VERSION
      protocol_string :client_id, value: "#{OrientdbBinary::NAME} #{OrientdbBinary::VERSION}, protocol v#{OrientdbBinary::CURRENT_PROTOCOL_VERSION}"
      protocol_string :user
      protocol_string :password
    end

    class ConnectAnswer < BinData::Record
      endian :big

      skip length: 4
      int32 :session
    end
  end
end
