module OrientdbBinary
  class Database < OrientdbBinary::OrientdbBase

    def self.connect(options)
      Database.new(options)
    end

    def open(args)
      connection = OrientdbBinary::Protocols::DbOpen.new(version: protocol, database_name: args[:db],
                                                          user: args[:user],
                                                          password: args[:password]
                                                        ).process(socket)

      @session = connection[:session]
      @opened = true if @session >= 0
      connection
    end

    def close
      OrientdbBinary::Protocols::DbClose.new(session: session).process(socket)
    end

    def reload
      OrientdbBinary::Protocols::DbReload.new(session: session).process(socket)
    end

    def size
    end

    def count_records
    end

    def add_datacluster
    end

    def drop_datacluster
    end

    def count_datacluster
    end

    def datarange_datacluster
    end

    def add_datasegment
    end

    def drop_datasegment
    end

    def load_record(cluster_id, cluster_position, fetch_plan, ignore_cache, load_tombstones)
      OrientdbBinary::Protocols::RecordLoad.new(
                                                session: session, cluster_id: cluster_id,
                                                cluster_position: cluster_position, fetch_plan: fetch_plan,
                                                ignore_cache: ignore_cache, load_tombstones: load_tombstones
                                              ).process(socket)
    end

    def create_record
    end

    def update_record
    end

    def delete_record
    end

    def count
    end

    # def query(text, params)
    #   class_name = 'com.orientechnologies.orient.core.sql.OCommandSQL'
    #   q = OrientdbBinary::Protocols::SqlCommandPayload.new text: text, serialized_params: "params:#{JSON.generate(params)}",
    #                                                       class_name: class_name
    #   _command(q.to_binary_s, class_name)
    # end

    # def script(text)
    #   class_name = 'com.orientechnologies.orient.core.sql.OCommandSQL'
    # end

    def command(text)
    end

    # def command(text)
    #   mode = 's'.ord
    #   class_name = 'com.orientechnologies.orient.core.sql.query.OSQLSynchQuery'
    #   fetchplan = "*0"

    #   query = OrientdbBinary::Protocols::SqlCommandPayload.new text: text, non_text_limit: -1, fetchplan: fetchplan
    #   p query

    #   # command = OrientdbBinary::Protocols::Command.new session: session, mode: mode, clazz_name: class_name, command_payload_length: query.to_binary_s.length, command_payload: query.to_binary_s
    #   command = OrientdbBinary::Protocols::Command.new session: session, mode: mode, text: text, command_payload: query.to_binary_s
    #   command.write(socket)

    #   status = BinData::Int8.read(socket).to_i
    #   process_errors(status)

    #   p OrientdbBinary::Protocols::CommandAnswer.read(socket)
    # end
    
    def tx_commit
    end

    private
    def _command(binary_query, class_name)
      mode = 's'.ord
      OrientdbBinary::Protocols::Command.new(
                                              session: session, mode: mode,
                                              command_payload_length: binary_query.length,
                                              command_payload: binary_query
                                            ).process(socket)
    end


  end
end
