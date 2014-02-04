require 'orientdb_binary/protocols/datacluster_add'
require 'orientdb_binary/protocols/datacluster_drop'
require 'orientdb_binary/protocols/datacluster_count'
require 'orientdb_binary/protocols/datacluster_datarange'
require 'orientdb_binary/protocols/datacluster_lh_cluster_is_used'

module OrientdbBinary
  module DatabaseOperations
    module DataCluster

      # Add datacluster.
      # name: string
      # optional parameters:
      # cluster_type: string (PHYSICAL or MEMORY), for memory databases it should be 'MEMORY', for local/plocal it can be either 'MEMORY or 'PHYSICAL'
      # datasegment_name: string (should exists, 'default' is used by default)
      # location: string
      # cluster_id: string, should be -1 for new clusters
      #
      # Usage:
      # db.add_datacluster(name: "posts") # uses default datasegment
      # If needed datasegment should be created before
      # db.add_datasegment(name: "posts")
      # db.add_datacluster(name: "posts", datasegment_name: "posts")
      #
      def add_datacluster(args)
        types = {
          local: 'PHYSICAL',
          plocal: 'PHYSICAL',
          memory: 'MEMORY'
        }

        defaults = {
          cluster_type: types[@db_params[:storage].to_sym],
          datasegment_name: "default",
          location: args[:name] + "_datacluster",
          cluster_id: -1
        }

        options = defaults.merge(args)

        OrientdbBinary::Protocols::DataclusterAdd.new(params(options)).process(socket)
      end

      # Find cluster by its parameter
      # Usage:
      # db.find_datacluster_by(name: 'default')
      # db.find_datacluster_by(id: 1)
      # Only first cluster is returned!
      #
      def find_datacluster_by(arg)
        key = arg.keys.first
        val = arg[key]
        @clusters.select {|cluster| cluster["#{key}".to_sym] == val}.first
      end

      # Drops datacluster
      # cluster_id: int
      # or
      # cluster_name: string
      # Usage:
      # db.drop_datacluster(cluster_id: 7)
      # db.drop_datacluster(cluster_name: 'posts')
      #
      def drop_datacluster(args)
        if args[:cluster_name] and not args[:cluster_id]
          if cluster=find_datacluster_by(cluster_name: args[:cluster_name])
            args[:cluster_id] = cluster[:cluster_id]
          end
        end
        OrientdbBinary::Protocols::DataclusterDrop.new(params(args)).process(socket)
      end

      # cluster_ids: array of ids
      # or
      # cluster_names: array of names
      # Usage:
      # db.count_datacluster(cluster_ids: [0,1,2,3])
      # db.count_datacluster(cluster_names: ['default', 'posts'])
      #
      def count_datacluster(args)
        if args[:cluster_names] and not args[:cluster_ids]
          args[:cluster_ids] = args[:cluster_names].map do |name|
            cluster = find_datacluster_by(cluster_name: name)
            cluster[:cluster_id] if cluster
          end
        end
        args[:cluster_ids] = args[:cluster_ids].delete_if {|cluster| !cluster}
        args[:cluster_count] = args[:cluster_ids].length

        OrientdbBinary::Protocols::DataclusterCount.new(params(args)).process(socket)
      end

      # cluster_id: int
      # or
      # cluster_name: string
      # Usage:
      # db.datarange_datacluster(cluster_id: 7)
      # db.datarange_datacluster(cluster_name: 'posts')
      #
      def datarange_datacluster(args)
        if args[:cluster_name] and not args[:cluster_id]
          if cluster=find_datacluster_by(cluster_name: args[:cluster_name])
            args[:cluster_id] = cluster[:cluster_id]
          end
        end
        OrientdbBinary::Protocols::DataclusterDatarange.new(params(args)).process(socket)
      end

      # it looks like it's not supported (?)
      def datacluster_lh_cluster_is_used()
        # OrientdbBinary::Protocols::DataclusterLhClusterIsUsed.new(session: session).process(socket)
        return nil
      end
    end
  end
end
