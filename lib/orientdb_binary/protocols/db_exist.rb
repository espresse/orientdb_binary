module OrientdbBinary
  module Protocols

    class DbExist < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_EXIST
      int32 :session

      protocol_string :database
      protocol_string :server_storage_type, value: 'memory'
    end

    class DbExistAnswer < BinData::Record
      endian :big

      skip length: 4
      int8 :exists
    end
  end
end
