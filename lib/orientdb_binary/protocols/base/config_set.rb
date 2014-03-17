module OrientdbBinary
  module BaseProtocol

    class ConfigSet < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_SET
      int32 :session

      protocol_string :config_key
      protocol_string :config_value
    end

    class ConfigSetAnswer < BinData::Record
      endian :big

      int32 :session
    end
  end
end
