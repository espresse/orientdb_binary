module OrientdbBinary
  module Protocols

    class DbDrop < BinData::Record
      include OrientdbBinary::Protocols::Base
      
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
