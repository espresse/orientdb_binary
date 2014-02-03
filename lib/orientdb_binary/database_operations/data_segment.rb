require 'orientdb_binary/protocols/datasegment_add'
require 'orientdb_binary/protocols/datasegment_drop'

module OrientdbBinary
  module DatabaseOperations
    module DataSegment

      # name: string
      # location: string
      # Usage:
      # db.add_datasegment(name: "posts")
      # db.add_datasegment(name: "posts", location: "posts_segments")
      #
      def add_datasegment(args)
        default = {
          location: args[:name] + "_segments"
        }
        options = default.merge(args)
        OrientdbBinary::Protocols::DatasegmentAdd.new(params(options)).process(socket)
      end

      # name: string
      # Usage:
      # db.drop_datasegment(name: 'posts')
      #
      def drop_datasegment(args)
        OrientdbBinary::Protocols::DatasegmentDrop.new(params(args)).process(socket)
      end
    end
  end
end
