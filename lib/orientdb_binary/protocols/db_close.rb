module OrientdbBinary
  module Protocols

    class DbClose < BinData::Record
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_CLOSE
      int32 :session

      def process(socket)
        write(socket)
      end
    end
  end
end
