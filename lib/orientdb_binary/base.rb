module OrientdbBinary
  class OrientdbBase
    attr_accessor :socket, :protocol, :session

    def initialize(options)
      defaults = {
        host: 'localhost',
        port: 2424
      }

      @options = defaults.merge(options)

      @server_connection = OrientdbBinary::Connection.new(@options)
      @socket = @server_connection.socket
      @connected = false
      @session = OrientdbBinary::OperationTypes::NEW_SESSION
    end

    def connected?
      @connected
    end

    def disconnect
      close
      @server_connection.close()
    end

    def close
      @session = OrientdbBinary::OperationTypes::NEW_SESSION
      @connected = false
    end

    private
    
    def params (args)
      args.merge(session: session)
    end

  end
end
