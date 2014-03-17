module OrientdbBinary
  module BaseProtocol

    class ConfigGet < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_GET
      int32 :session

      protocol_string :config_key
    end

    class ConfigGetAnswer < BinData::Record
      endian :big

      int32 :session
      protocol_string :config_value
    end
  end
end
