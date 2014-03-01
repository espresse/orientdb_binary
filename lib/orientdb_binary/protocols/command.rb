module OrientdbBinary
  module Protocols

    class SqlCommandPayload < BinData::Record
      endian :big

      protocol_string :class_name
      protocol_string :text
      int32 :non_text_limit, value: -1
      protocol_string :fetch_plan, initial_value: '*:0'
      protocol_string :serialized_params
    end

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
    end

    class CommandAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :result_type

      int32 :collection_size, onlyif: -> {result_type == 108}
      array :collection, initial_length: -> {result_type == 114 ? 1 : collection_size}, onlyif: -> {result_type == 108 or result_type == 114} do
        int16 :marker
        int8 :record_type
        int16 :cluster_id
        int64 :position
        int32 :version
        protocol_string :record_content
      end

      array :prefetched_records, read_until: -> {element.payload_status == 0} do
        int8  :payload_status
        int16 :marker, onlyif: -> {payload_status > 0}
        int8 :record_type, onlyif: -> {payload_status > 0}
        int16 :cluster_id, onlyif: -> {payload_status > 0}
        int64 :position, onlyif: -> {payload_status > 0}
        int32 :version, onlyif: -> {payload_status > 0}
        protocol_string :record_content, onlyif: -> {payload_status > 0}
      end

    end



  end
end
