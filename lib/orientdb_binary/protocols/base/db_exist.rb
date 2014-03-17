module OrientdbBinary
  module BaseProtocol

    class DbExist < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_EXIST
      int32 :session

      protocol_string :name
      protocol_string :storage
    end

    class DbExistAnswer < BinData::Record
      endian :big

      skip length: 4
      int8 :exists
    end
  end
end
