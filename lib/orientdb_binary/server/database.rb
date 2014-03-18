module OrientdbBinary
  class Server

    # This class contains the behaviour for databases administration.
    # Every action here requires admin privileges!
    class Database
      attr_reader :name, :storage, :type, :connection

      # Initialize database admin operations on server
      #
      # @example Initializing database operations
      #
      #   connection = OrientdbBinary::Connection.new(host: host, port: port)
      #   server = OrientdbBinary::Server.new(connection, user: user, password: password)
      #   database_operations = OrientdbBinary::Database.initialize_with(connection)
      #
      # @param [OrientdbBinary::Connection]
      #
      # @since 1.0
      def self.initialize_with(connection)
        Database.new(connection)
      end

      def initialize(connection)
        @connection = connection
      end

      # Defines database parameters
      #
      # @param [Hash] **args [:name, :storage, :type], :storage and :type are optional
      #
      # @since 1.0
      def new(**args)
        @name = args[:name]
        @storage = args[:storage] || :memory
        @type = args[:type] || :document
        self
      end

      # Checks database existance
      #
      # @return [true, false] True if database exists, False if not
      #
      # @since 1.0
      def exists?
        answer = connection.protocol::DbExist.new(params).process(connection)

        answer[:exists] == 1
      end

      # Creates database with provided parameters
      #
      # @since 1.0
      def save!
        connection.protocol::DbCreate.new(params).process(connection)
      end

      # Drops database
      #
      # @since 1.0
      def drop!
        connection.protocol::DbDrop.new(params).process(connection)
      end

      # Freezes database
      #
      # @since 1.0
      def freeze!
        connection.protocol::DbFreeze.new(params).process(connection)
      end

      # Releases previously frozen database
      #
      # @since 1.0
      def release!
        connection.protocol::DbRelease.new(params).process(connection)
      end

      # Lists all databases
      #
      # @return A hash where keys are databases' names and values are their storages' locations
      #
      # @since 1.0
      def list
        connection.protocol::DbList.new(params).process(connection).process
      end

      private

      # Returns a hash of parameters
      #
      # @api private
      #
      # @since 1.0
      def params(args = {})
        { session: connection.session, name: name.to_s, storage: storage.to_s, type: type.to_s }
      end

    end
  end
end
