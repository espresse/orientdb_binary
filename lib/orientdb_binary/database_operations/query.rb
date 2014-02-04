require 'orientdb_binary/protocols/command'

module OrientdbBinary
  module DatabaseOperations
    module Query
      def query(text, params, fetch_plan="*:0")
        class_name = 'com.orientechnologies.orient.core.sql.query.OSQLSynchQuery'
        serialized_params = OrientdbBinary::Parser::Serializer.new.serialize_document({params: params})
        q = OrientdbBinary::Protocols::SqlCommandPayload.new text: text, serialized_params: serialized_params,
                                                            fetch_plan: fetch_plan,
                                                            class_name: class_name
        _command(q.to_binary_s, class_name)
      end

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
end
