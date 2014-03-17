module OrientdbBinary
  class Server

    # This class contains the behaviour for config operations.
    # Every action here requires admin privileges!
    class Config
      attr_reader :connection

      def initialize(connection)
        @connection = connection
      end

      # Gets config value by key
      #
      # @param [String, Symbol] key
      #
      # @return config value
      #
      # @since 1.0
      def get(key)
        val = connection.protocol::ConfigGet.new(params(config_key: key)).process(connection)
        val[:config_value]
      end

      # Sets config value
      #
      # @param [Symbol, String] key
      # @param [String] value
      #
      # @since 1.0
      def set(key, value)
        connection.protocol::ConfigSet.new(params(config_key: key.to_s, config_value: value.to_s)).process(connection)
      end

      # Lists all configs
      #
      # @return A hash where keys are databases' names and values are their storages' locations
      #
      # @since 1.0
      def list
        lst = connection.protocol::ConfigList.new(params).process(connection)
        lst[:config_list] || []
      end

      private

      # Returns a hash of parameters
      #
      # @api private
      #
      # @since 1.0
      def params(args = {})
        args.merge session: connection.session
      end
    end
  end
end
