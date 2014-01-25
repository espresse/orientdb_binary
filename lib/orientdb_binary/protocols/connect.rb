module OrientdbBinary
  module Protocols
    class Connect < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONNECT
      int32 :session, value: OrientdbBinary::OperationTypes::NEW_SESSION

      protocol_string :driver, value: OrientdbBinary::NAME
      protocol_string :driver_version, value: OrientdbBinary::VERSION
      int16 :protocol, value: OrientdbBinary::PROTOCOL_VERSION
      protocol_string :client_id, value: "#{OrientdbBinary::NAME} #{OrientdbBinary::VERSION}, protocol v#{OrientdbBinary::PROTOCOL_VERSION}"
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
