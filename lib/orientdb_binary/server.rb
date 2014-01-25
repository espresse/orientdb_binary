module OrientdbBinary
  class Server < OrientdbBinary::OrientdbBase
    def self.connect(options)
      Server.new(options)
    end

    def connect(args)
      connection = OrientdbBinary::Protocols::Connect.new(
                                                            protocol: protocol,
                                                            user: args[:user],
                                                            password: args[:password]
                                                          ).process(socket)
      @session = connection[:session] || OrientdbBinary::OperationTypes::NEW_SESSION
      @connected = true if @session > OrientdbBinary::OperationTypes::NEW_SESSION
      connection
    end

    def db_exists?(name)
      answer = OrientdbBinary::Protocols::DbExist.new(session: session, database: name).process(socket)
      answer[:exists] == 1
    end

    def db_create(name, type, storage)
      OrientdbBinary::Protocols::DbCreate.new(session: session, name: name, type: type, storage: storage).process(socket)
    end

    def db_drop(name, storage)
      OrientdbBinary::Protocols::DbDrop.new session: session, name: name, storage: storage
    end

    def get_config(key)
      OrientdbBinary::Protocols::ConfigGet.new(session: session, option_key: key).process(socket)
    end

    def set_config(key, value)
      OrientdbBinary::Protocols::ConfigSet.new(session: session, option_key: key.to_s, option_value: value.to_s).process(socket)
    end

    def config_list
      OrientdbBinary::Protocols::ConfigList.new(session: session).process(socket)
    end

    def shutdown
      OrientdbBinary::Protocols::Shutdown.new(session: session, user: @options[:user], password: @options[:password]).process(socket)
    end

  end
end
