module OrientdbBinary
  module Protocols

    class ConfigSet < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_SET
      int32 :session

      protocol_string :option_key
      protocol_string :option_value
    end

    class ConfigSetAnswer < BinData::Record
      endian :big

      int32 :session
    end
  end
end
