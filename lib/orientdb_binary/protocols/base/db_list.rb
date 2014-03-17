module OrientdbBinary
  module BaseProtocol

    class DbList < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_LIST
      int32 :session
    end

    class DbListAnswer < BinData::Record
      endian :big

      int32 :session
      protocol_string :list

      def process
        doc = OrientdbBinary::Parser::Deserializer.new().deserialize(list)
        return (doc[:databases] ? doc[:databases] : {})
      end
    end


  end
end
