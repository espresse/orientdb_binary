module OrientdbBinary
  module BaseProtocol

    class DbDrop < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_DROP
      int32 :session

      protocol_string :name
      protocol_string :storage
    end

    class DbDropAnswer < BinData::Record
      endian :big

      skip length: 4
    end
  end
end
