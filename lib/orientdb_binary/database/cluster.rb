module OrientdbBinary
  class Database
    class Cluster
      attr_reader :name, :location, :database, :segment_name, :segment_id, :cluster_type, :cluster_id

      TYPES = {
        local: "PHYSICAL",
        plocal: "PHYSICAL",
        memory: "MEMORY"
      }

      # Initialize connection to clusters
      #
      # @since 1.0
      def self.initialize_with(database)
        Cluster.new(database)
      end

      # Initialize connection to clusters
      #
      # @since 1.0
      def initialize(database)
        @database = database
      end

      # Lists all clusters in database
      #
      # @since 1.0
      def list
        database.clusters
      end

      # Search for cluster by keyword
      #
      # @param [Hash] key => value Possible values of key: :name, :cluster_id
      #
      # @return Cluster
      #
      # @since 1.0
      def find(arg)
        key = arg.keys.first
        val = arg[key]

        clust = list.select {|cluster| cluster["#{key}".to_sym] == val}.first

        if clust
          _clust = {}

          cluster = Cluster.new self.database
          clust.each_pair { |k,v| _clust[k] = v }

          return cluster.new _clust
        end
        nil
      end


      def count(**args)
        args[:cluster_ids] = args[:cluster_ids] ? args[:cluster_ids] : convert_names_to_ids(args)

        args[:cluster_count] = args[:cluster_ids].length
        database.connection.protocol::DataclusterCount.new(params(args)).process(database.connection)[:records_count]
      end

      def data_range
        args[:cluster_id] = convert_name_to_id(args[:cluster_name], args[:cluster_id])

        database.connection.protocol::DataclusterDatarange.new(params(args)).process(database.connection)
      end

      # Initialize cluster params
      #
      # @param [String, Symbol] name
      #
      # @since 1.0
      def new(name:, segment_name: nil, segment_id: nil, location: nil, cluster_type: nil, cluster_id: -1)
        @name = name.to_s
        @location = location || @name + "_cluster"
        @cluster_type = cluster_type || TYPES[database.storage.to_sym]
        @cluster_id = cluster_id
        @segment = segment_name
        @segment_id = segment_id

        self
      end

      # Creates data cluster with provided data
      #
      # @return [Integer] segment id
      #
      # @since 1.0
      def create!
        unless segment_id
          database.connection.protocol::DataclusterAdd.new(params).process(database.connection)
        end
      end

      # Removes cluster by its name or id
      #
      # @return [True, False] True if succeed, false if not
      #
      # @since 1.0
      def drop!
        args[:cluster_id] = convert_name_to_id(args[:cluster_name], args[:cluster_id])
        database.connection.protocol::DataclusterDrop.new(params(args)).process(database.connection)
      end

      private

      # Creates params from data
      #
      # @api private
      #
      # @since 1.0
      def params(args)
        args.merge({ session: database.connection.session, name: name, location: location, cluster_type: cluster_type,  segment_name: segment_name, cluster_id: cluster_id })
      end

      def convert_name_to_id(name, id)
        if name and not id
          if (_cluster = find(cluster_name: name))
            id = cluster[:cluster_id]
          end
        end
        id
      end

      def convert_names_to_ids(args)
        ids = []
        unless args[:cluster_ids]
          ids = args[:cluster_names].map do |name|
            convert_name_to_id(name, nil)
          end
        end
        ids
      end
    end
  end
end
