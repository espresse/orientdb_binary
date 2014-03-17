# require 'orientdb_binary/protocols/command'

# module OrientdbBinary
#   module DatabaseOperations
#     module Query
#       def query(text, params, fetch_plan="*:0")
#         class_name = 'com.orientechnologies.orient.core.sql.query.OSQLSynchQuery'
#         serialized_params = OrientdbBinary::Parser::Serializer.new.serialize_document({params: params})
#         q = OrientdbBinary::Protocols::SqlCommandPayload.new text: text, serialized_params: serialized_params,
#                                                             fetch_plan: fetch_plan,
#                                                             class_name: class_name
#         _command(q.to_binary_s, class_name)
#       end

#       # def script(text)
#       #   class_name = 'com.orientechnologies.orient.core.sql.OCommandSQL'
#       # end

#       def command(text, params={})
#         class_name = 'com.orientechnologies.orient.core.sql.OCommandSQL'
#         fetch_plan = nil
#         serialized_params = OrientdbBinary::Parser::Serializer.new.serialize_document({params: params})
#         q = OrientdbBinary::Protocols::SqlCommandPayload.new text: text, serialized_params: serialized_params,
#                                                             fetch_plan: fetch_plan,
#                                                             class_name: class_name
#         _command(q.to_binary_s, class_name)
#       end

#       private
#       def _command(binary_query, class_name)
#         mode = 's'.ord
#         OrientdbBinary::Protocols::Command.new(
#                                                 session: session, mode: mode,
#                                                 command_payload_length: binary_query.length,
#                                                 command_payload: binary_query
#                                               ).process(socket)
#       end
#     end
#   end
# end
