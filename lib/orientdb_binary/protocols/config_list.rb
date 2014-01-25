module OrientdbBinary
  module Protocols

    class ConfigList < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_CONFIG_LIST
      int32 :session
    end

    class ConfigListAnswer < BinData::Record
      endian :big

      int32 :session
      int16 :config_count
      array :config_list, initial_length: :config_count do
        protocol_string :option_key
        protocol_string :option_value
      end
    end
  end
end
