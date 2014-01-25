module OrientdbBinary
  module Protocols

    class DbClose < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_CLOSE
      int32 :session
    end

    class DbCloseAnswer < BinData::Record
      endian :big
    end
  end
end
