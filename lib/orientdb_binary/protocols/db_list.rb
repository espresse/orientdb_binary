module OrientdbBinary
  module Protocols

    class DbList < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_LIST
      int32 :session
    end

    class DbListAnswer < BinData::Record
      endian :big

      int32 :session
      protocol_string :list

      def process
        OrientdbBinary::Parser::Deserializer.new().deserialize(list)
      end
    end


  end
end
