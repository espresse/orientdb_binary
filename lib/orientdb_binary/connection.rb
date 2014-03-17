module OrientdbBinary
  class ProtocolVersionError < StandardError; end

  # This class contains the behaviour for managing connections
  class Connection

    attr_accessor :socket, :protocol, :session

    # Initializes connection
    #
    # @param [Hash] options
    #
    # @option [String, Symbol] host Host name
    # @option [String, Symbol] port Port number
    #
    # @since 1.0
    def initialize(options = {})
      @options = options
      connect
    end

    # Establishes connection with OrientDb Socket
    #
    # @since 1.0
    def connect
      @socket = TCPSocket.open(@options[:host], @options[:port])
      @server_protocol_version = BinData::Int16be.read(socket)

      # minimal protocol version we are supporting is 19
      raise ProtocolVersionError, "Protocols 19 and above are supported. Please upgrade your OrientDb server." if @server_protocol_version < 19

      server_protocol_string = "OrientdbBinary::Protocol::Protocol#{@server_protocol_version}"
      constant = Object.const_defined?(server_protocol_string) ? Object.const_get(server_protocol_string) : OrientdbBinary::Protocol::Protocol19
      @protocol = constant
    end

    # Closes the connection
    #
    # @since 1.0
    def close
      socket.close
      @protocol = nil
    end

    # Shortcut for server operations
    #
    # @example
    #
    #  connection = OrientdbBinary::Connection.new(host: host, port: port)
    #  server = connection.server(user: user, password: password)
    #
    # @param [Hash] options
    #
    # @option [String] user OrientDb's root login
    # @option [String] user OrientDb's root password
    #
    # @since 1.0
    def server(options = {})
      srv = Server.new(self, options)
      @session = srv.session
      srv
    end

    def database(options = {})
      db = Database.new(self, options)
      @session = db.session
      db
    end
  end
end
