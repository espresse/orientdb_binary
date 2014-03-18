require 'singleton'

module TestHelper

  SERVER        = { host: 'localhost', port: 2424 }
  SERVER_USER   = { user: 'root', password: 'root' }

  TEST_DB       = { name: 'ruby-orientdb-test-database-01', storage: "memory", type: :document }
  TEST_DB_USER  = { user: 'admin', password: 'admin' }

  class Server
    include Singleton

    def initialize
      @connection = OrientdbBinary::Connection.new(TestHelper::SERVER)
      @server = @connection.server(TestHelper::SERVER_USER)
    end

    def server
      @server
    end

    def connection
      @connection
    end
  end

  class Database
    include Singleton

    attr_reader :database, :connection

    def initialize
      @connection = OrientdbBinary::Connection.new(TestHelper::SERVER)
      create_database
    end

    def create_database
      server = @connection.server(TestHelper::SERVER_USER)
      db = server.database.new(TestHelper::TEST_DB)
      db.drop! if db.exists?
      db.save!

      db = @connection.database(TestHelper::TEST_DB.merge(TestHelper::TEST_DB_USER))
      @database = db.open
    end

    def database
      @database
    end
  end
end

