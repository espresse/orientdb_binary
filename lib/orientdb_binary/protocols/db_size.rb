module OrientdbBinary
  module Protocols

    class DbSize < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_SIZE
      int32 :session
    end

    class DbSizeAnswer < BinData::Record
      endian :big

      long :db_size
    end
  end
end
