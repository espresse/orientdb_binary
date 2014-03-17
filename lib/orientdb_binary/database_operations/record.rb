# require 'orientdb_binary/protocols/record_load'
# require 'orientdb_binary/protocols/record_create'
# require 'orientdb_binary/protocols/record_update'
# require 'orientdb_binary/protocols/record_delete'
# require 'orientdb_binary/protocols/db_countrecords'

# module OrientdbBinary
#   module DatabaseOperations
#     module Record

#       # rid: #id:position / id:position
#       # or
#       # cluster_id: int
#       # cluster:position: int
#       # optional
#       # fetch_plan: string (by default used "*:0")
#       # ignore_cache: int (0-1, by default 1)
#       # load_tombstones: int (0-1, by default 0)
#       # Usage:
#       # db.load_record("#5:2")
#       # db.load_record("#5:2", fetch_plan: "*:-1")
#       # db.load_record(5, 2, fetch_plan: "*:-1", ignore_cache: 0, load_tombstones: 1)
#       #
#       def load_record(args)
#         if args[:rid]
#           match = args[:rid].match(/#*(?<id>\d+):(?<position>\d+)/)
#           args[:cluster_id] = match[:id].to_i
#           args[:cluster_position] = match[:position].to_i
#         end
#         defaults = {
#           fetch_plan: "*:0",
#           ignore_cache: 1,
#           load_tombstones: 0
#         }
#         options = defaults.merge(args)
#         answer = OrientdbBinary::Protocols::RecordLoad.new(params(options)).process(socket)
#         unless answer[:exceptions]
#           answer.process(options)
#         end
#       end

#       # Create record from object
#       # Usage:
#       # record = {
#       #   :@class => "Posts",
#       #   :@type => "d",
#       #   :@cluster => "posts"
#       #   name: "some name"
#       #   param: "some param"
#       # }
#       # Usage:
#       # db.create_record_from_object(record)
#       #
#       def create_record_from_object(record)
#         record_type = record[:@type] ? record[:@type].ord : "d".ord
#         cluster_id = (cluster = find_datacluster_by(cluster_name: 'default')) ? cluster[:cluster_id] : nil

#         if record[:@cluster]
#           if record[:@cluster].is_a? Integer
#             cluster_id = record[:@cluster]
#           else
#             cluster_id = (cluster = find_datacluster_by(cluster_name: record[:@cluster].downcase)) ? cluster[:cluster_id] : cluster_id
#           end
#         elsif record[:@class]
#           cluster_id = (cluster = find_datacluster_by(cluster_name: record[:@class].downcase)) ? cluster[:cluster_id] : cluster_id
#         end

#         record_content = OrientdbBinary::Parser::Serializer.new.serialize_document(record)
#         create_record(record_type: record_type, cluster_id: cluster_id, record_content: record_content)
#       end

#       # Create record
#       # cluster_id: int or cluster_name: string
#       # record_content: string -> it's serialized document; use create_record_from_object which serialize hash into string accepted by Orientdb
#       # Usage:
#       # db.create_record(cluster_id: 5, record_content: "Post@title=\"Post title\"")
#       #
#       def create_record(args)
#         if args[:cluster_name] and not args[:cluster_id]
#           args[:cluster_id] = (cluster = find_datacluster_by(cluster_name: args[:cluster_name])) ? cluster_id : nil
#         end

#         defaults = {
#           datasegment_id: -1,
#           record_type: "d".ord,
#           mode: 0
#         }

#         options = defaults.merge(args)
#         answer = OrientdbBinary::Protocols::RecordCreate.new(params(args)).process(socket)
#         answer.process(options)
#       end

#       def update_record(args)
#         OrientdbBinary::Protocols::RecordUpdate.new(params(args)).process(socket)
#       end

#       def delete_record(args)
#         OrientdbBinary::Protocols::RecordDelete.new(params(args)).process(socket)
#       end

#       def count_records
#         OrientdbBinary::Protocols::DbCountRecords.new(params).process(socket)
#       end

#       def register_script(opts)
#         default = {
#           :@class => "OFunction",
#           :@cluster => "ofunction",
#           language: "javascript",
#           parameters: [],
#           idempotent: nil,
#           code: nil,
#           name: nil
#         }

#         record = default.merge(opts)
#         create_record_from_object(record)
#       end

#     end
#   end
# end
