module OrientdbBinary
  module Protocols
    class Errors < BinData::Record
      endian :big

      int32 :session
      array :exceptions, read_until: -> { element[:is_error] > 0 } do
        int8 :is_error
        protocol_string :exception_class
        protocol_string :exception_message
      end
    end
  end

  class ProtocolError < StandardError
      attr_reader :session, :exception_class

      def initialize(session, *exceptions)
        @session
        @exception_class = exceptions[0] && exceptions[0][:exception_class]

        super exceptions.map { |exp| [ exp[:exception_class], exp[:exception_message] ].reject { |s| s.nil? }.join(': ') }.join("\n")
      end
  end
end
