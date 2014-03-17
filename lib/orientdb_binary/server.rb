require_relative 'server/database'
require_relative 'server/config'

module OrientdbBinary
  class Server
    attr_reader :connection, :session

    # Initializes connection to server actions
    #
    # @example
    #
    #  connection = OrientdbBinary::Connection.new(host: host, port: port)
    #  server = OrientdbBinary::Server.new(connection, user: user, password: password)
    #
    # @param [Hash] options
    #
    # @option [String] user OrientDb's root login
    # @option [String] user OrientDb's root password
    #
    # @since 1.0
    def initialize(connection_to_socket, args = {})
      @connection = connection_to_socket
      @user = args[:user]
      @password = args[:password]

      srv = connection.protocol::Connect.new(
                                protocol: 19,
                                user: args[:user],
                                password: args[:password]
                              ).process(connection)

      @session = srv[:session] || OrientdbBinary::OperationTypes::NEW_SESSION
    end

    # Shortcut for database operations
    #
    # @since 1.0
    def database
      Database.initialize_with(connection)
    end

    # Shortcut for config manipulations
    #
    # @since 1.0
    def config
      Config.new(connection)
    end

    # Shutdowns server
    #
    # @since 1.0
    def shutdown!
        connection.protocol::Shutdown.new(session: session, user: @user, password: @password).process(connection)
    end

  end
end
