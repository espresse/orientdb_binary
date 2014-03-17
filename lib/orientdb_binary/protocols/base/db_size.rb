module OrientdbBinary
  module BaseProtocol

    class DbSize < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_SIZE
      int32 :session
    end

    class DbSizeAnswer < BinData::Record
      endian :big

      int32 :session
      int64 :db_size
    end
  end
end
