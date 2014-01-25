module OrientdbBinary
  module Protocols

    class DbCountRecords < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_COUNTRECORDS
      int32 :session
    end

    class DbCountRecordsAnswer < BinData::Record
      endian :big

      int32 :session
      int64 :count_records
    end
  end
end
