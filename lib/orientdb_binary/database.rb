module OrientdbBinary
  class Database
    attr_reader :connection, :clusters, :session

    # Initializes connection to database
    #
    # @since 1.0
    def initialize(connection_to_socket, args = {})
      @connection = connection_to_socket

      @user = args[:user]
      @password = args[:password]
      @name = args[:name]
      @storage = args[:storage]

      open
    end

    # Opens connection to database
    #
    # @since 1.0
    def open
      conn = connection.protocol::DbOpen.new(params(name: @name, storage: @storage, user: @user, password: @password)).process(connection)
      @session = conn[:session] || OrientdbBinary::OperationTypes::NEW_SESSION

      @clusters = conn[:clusters]
      self
    end

    # Checks if database is opened
    #
    # @return true if database is open
    #
    # @since 1.0
    def opened?
      @session > -1 ? true : false
    end

    # Closes database
    #
    # @since 1.0
    def close
      connection.protocol::DbClose.new(params).process(connection)
      @session = OrientdbBinary::OperationTypes::NEW_SESSION
      @clusters = nil
    end

    # Reloads information about database.
    #
    # @since 1.0
    def reload
      answer = connection.protocol::DbReload.new(params).process(connection)
      @clusters = answer[:clusters]
      self
    end

    # Fetches database size
    #
    # @since 1.0
    def size
      connection.protocol::DbSize.new(params).process(connection)[:db_size]
    end

    def segment
    end

    def cluster
    end

    def record
    end

    def command
    end

    def transaction
    end

    # Returns a hash of parameters
    #
    # @api private
    #
    # @since 1.0
    def params(args = {})
      args.merge({ session: connection.session })
    end
  end
end
