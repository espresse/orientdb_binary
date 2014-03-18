module OrientdbBinary
  module BaseProtocol

    class DbClose < BinData::Record

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_CLOSE
      int32 :session

      def process(connection)
        write(connection.socket)
      end
    end
  end
end
