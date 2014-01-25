module OrientdbBinary
  module Protocols

    class DbCountRecords < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_SIZE
      int32 :session
    end

    class DbCountRecordsAnswer < BinData::Record
      endian :big

      long :count_records
    end
  end
end
