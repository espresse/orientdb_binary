module OrientdbBinary
  module Protocols

    class ConfigGet < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_GET
      int32 :session

      protocol_string :option_key
    end

    class ConfigGetAnswer < BinData::Record
      endian :big

      int32 :session
      protocol_string :option_value
    end
  end
end
