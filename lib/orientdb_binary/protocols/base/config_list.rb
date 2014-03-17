module OrientdbBinary
  module BaseProtocol

    class ConfigList < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_LIST
      int32 :session
    end

    class ConfigListAnswer < BinData::Record
      endian :big

      int32 :session
      int16 :config_count
      array :config_list, initial_length: :config_count do
        protocol_string :config_key
        protocol_string :config_value
      end
    end
  end
end
