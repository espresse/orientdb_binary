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
    end

    def connected?
      @connected
    end

    def disconnect
      close
      @server_connection.close()
    end

    def close
    end

  end
end
