module OrientdbBinary
  module Protocols

    class Shutdown < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_SHUTDOWN
      int32 :session
      protocol_string :user
      protocol_string :password
    end

    class ShutdownAnswer < BinData::Record
      endian :big

      rest :message
    end
  end
end
