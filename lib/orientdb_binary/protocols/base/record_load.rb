module OrientdbBinary
  module BaseProtocol

    class RecordLoad < BinData::Record
      include OrientdbBinary::BaseProtocol::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_RECORD_LOAD
      int32 :session

      int16 :cluster_id
      int64 :cluster_position
      protocol_string :fetch_plan
      int8 :ignore_cache
      int8 :load_tombstones
    end

    class RecordLoadAnswer < BinData::Record
      endian :big

      int32 :session
      int8 :payload_status
      array :collection, initial_length: :payload_status do
        protocol_string :content
        int32 :version
        record_type :record_type
      end

      array :prefetched_records, read_until: -> {element.payload_status == 0}, onlyif: -> {payload_status > 0} do
        int8  :payload_status
        int16 :marker, onlyif: -> {payload_status > 0}
        record_type :record_type, onlyif: -> {payload_status > 0}
        int16 :cluster_id, onlyif: -> {payload_status > 0}
        int64 :position, onlyif: -> {payload_status > 0}
        int32 :version, onlyif: -> {payload_status > 0}
        protocol_string :content, onlyif: -> {payload_status > 0}
      end

      def process(options)
        colls = self.collection.map do |record|
          opts = {
            :@rid => "##{options[:cluster_id]}:#{options[:cluster_position]}",
            :@version => record[:version],
            :@type => record[:record_type]
          }
          OrientdbBinary::Parser::Deserializer.new().deserialize(record[:content], opts)
        end

        prefetched = self.prefetched_records.map do |record|
          if record[:payload_status] > 0
            opts = {
              :@rid => "##{record[:cluster_id]}:#{record[:position]}",
              :@version => record[:version],
              :@type => record[:record_type]
            }
            OrientdbBinary::Parser::Deserializer.new().deserialize(record[:content], opts)
          end
        end

        {collection: colls, prefetched_records: prefetched.delete_if {|rec| !rec}}
      end
    end
  end
end
