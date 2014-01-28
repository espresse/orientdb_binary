module OrientdbBinary
  module Protocols

    class DbCreate < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_CREATE
      int32 :session

      protocol_string :name
      protocol_string :type
      protocol_string :storage
    end

    class DbCreateAnswer < BinData::Record
      endian :big

      skip length: 4
    end
  end
end
