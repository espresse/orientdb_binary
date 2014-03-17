module OrientdbBinary
  class Database
    attr_reader :connection, :clusters

    def initialize(connection_to_socket, args = {})
      p connection_to_socket
      @connection = connection_to_socket

      @user = args[:user]
      @password = args[:password]
      @name = args[:name]
      @storage = args[:storage]

      open
    end

    def open
      conn = connection.protocol::DbOpen.new(params(name: @name, storage: @storage, user: @user, password: @password)).process(connection)
      @session = conn[:session]

      @clusters = conn[:clusters]
      self
    end

    def opened?
      @session > -1 ? true : false
    end

    def close
      connection.protocol::DbClose.new(params).process(connection)
    end

    def reload
      answer = connection.protocol::DbReload.new(params).process(connection)
      @clusters = answer[:clusters]
      self
    end

    def size
      connection.protocol::DbSize.new(params).process(connection)
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
  end
end
