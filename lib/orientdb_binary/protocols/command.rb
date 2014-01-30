module OrientdbBinary
  module Protocols

    # class SqlCommandPayload < BinData::Record
    #   endian :big

    #   protocol_string :text
    #   int32 :non_text_limit
    #   protocol_string :fetchplan
    #   protocol_string :serialized_params, value: "params:[name:\"admin\"]"
    # end

    # class SqlCommandPayload < BinData::Record
    #   endian :big

    #   protocol_string :class_name
    #   protocol_string :text
    #   int32 :non_text_limit, value: -1
    #   protocol_string :fetchplan, value: '*:-1'
    #   protocol_string :serialized_params
    #   # int8 :with_params, value: 1
    #   # int8 :composite_key_params_present, value: 0
    # end
    class Recordd < BinData::Primitive
      endian :big

      array :records do
            int16 :marker
            int8 :record_type
            int16 :cluster_id
            int64 :position
            int32 :version
            record_content :record_content
      end
    end

    class SqlCommandPayload < BinData::Record
      endian :big

      protocol_string :class_name
      protocol_string :text
      int32 :non_text_limit, value: -1
      protocol_string :fetch_plan, initial_value: '*:0'
      protocol_string :serialized_params
    end

    class CommandAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :synch_result_type

      int32 :collection_size
      array :collection, initial_length: :collection_size do
        int16 :marker
        int8 :record_type
        int16 :cluster_id
        int64 :position
        int32 :version
        record_content :record_content
      end
      array :prefetched_records, read_until: -> {element.payload_status == 0} do
        int8  :payload_status        
        int16 :marker, onlyif: -> {payload_status > 0}
        int8 :record_type, onlyif: -> {payload_status > 0}
        int16 :cluster_id, onlyif: -> {payload_status > 0}
        int64 :position, onlyif: -> {payload_status > 0}
        int32 :version, onlyif: -> {payload_status > 0}
        record_content :record_content, onlyif: -> {payload_status > 0}
        
      end

    end


    # class SqlCommandPayload < BinData::Record
    #   endian :big

    #   protocol_string :class_name, value: 'com.orientechnologies.orient.core.sql.OCommandSQL'
    #   protocol_string :text, value: 'SELECT FROM OUser WHERE name = :name'
    #   # protocol_string :fetchplan, value: '*:1'
    #   int8 :with_params, value: 1
    #   protocol_string :serialized_params, value: 'params:{"name":"admin"}'
    #   int8 :composite_key_params_present, value: 0
    # end

    class ScriptCommandPayload < BinData::Record
      endian :big

      protocol_string :language
      protocol_string :text
      int32 :non_text_limit
      protocol_string :fetchplan
      int32 :serialized_params, value: 0
    end

    class Command < BinData::Record
      include OrientdbBinary::Protocols::Base
      
      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_COMMAND
      int32 :session

      bit8 :mode
      protocol_string :command_payload

      def process(socket)
        write(socket)

        status = BinData::Int8.read(socket).to_i
        process_errors(socket, status)

        p constantize("#{self.class.to_s}Answer").read(socket)
      end
    end

    # class CommandAnswer < BinData::Record
    #   endian :big

    #   int32 :session
    #   int8 :synch_result_type
    #   int32 :collection_size
    #   array :collection, initial_length: :collection_size do
    #     int16 :marker
    #     int8 :record_type
    #     int16 :cluster_id
    #     int64 :position
    #     int32 :version
    #     record_content :record_content
    #   end
    # end
  end
end


# if ($this->mode == OrientDB::COMMAND_QUERY || $this->mode == OrientDB::COMMAND_SELECT_SYNC || $this->mode == OrientDB::COMMAND_SELECT_GREMLIN) {
#             $this->addByte(self::MODE_SYNC);
#         } else {
#             $this->addByte(self::MODE_ASYNC);
#         }
#         if ($this->mode == OrientDB::COMMAND_SELECT_ASYNC) {
#             $objName = 'com.orientechnologies.orient.core.sql.query.OSQLAsynchQuery';
#         } elseif ($this->mode == OrientDB::COMMAND_SELECT_SYNC) {
#             $objName = 'com.orientechnologies.orient.core.sql.query.OSQLSynchQuery';
#         } elseif ($this->mode == OrientDB::COMMAND_SELECT_GREMLIN) {
#             $objName = 'com.orientechnologies.orient.graph.gremlin.OCommandGremlin';
#         } else {
#             $objName = 'com.orientechnologies.orient.core.sql.OCommandSQL';
#         }
# $buff = '';
#         // Java query object name serialization
#         $buff .= pack('N', strlen($objName));
#         $buff .= $objName;
#         // Query text serialization in TEXT mode
#         $buff .= pack('N', strlen($this->query));
#         $buff .= $this->query;
#         if ($this->mode == OrientDB::COMMAND_SELECT_ASYNC || $this->mode == OrientDB::COMMAND_SELECT_SYNC || $this->mode == OrientDB::COMMAND_SELECT_GREMLIN) {
#             // Limit set to -1 to ignore and use TEXT MODE
#             $buff .= pack('N', -1);
#             // Add a fetchplan
#             $buff .= pack('N', strlen($this->fetchPlan));
#             $buff .= $this->fetchPlan;
#         }
#         // Params serialization, we have 0 params
#         $buff .= pack('N', 0);
#         // Now query object serialization complete, add it to command bytes
#         $this->addString($buff);
