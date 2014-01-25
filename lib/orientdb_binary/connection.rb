module OrientdbBinary
  class Connection

    attr_accessor :socket, :protocol

    def initialize(options)
      @socket = TCPSocket.open(options[:host], options[:port])
      @protocol = BinData::Int16be.read(socket)
    end

    def close
      socket.close
      @protocol = nil
    end

  end
end
