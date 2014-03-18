module OrientdbBinary
  class Database
    class Segment
      attr_reader :name, :location

      def initialize_with(database)
      end

      def initialize(**args)
        @name = args[:name].to_s
        @location = args[:location] || @name + "_segments"
      end

      def create
        database.connection.protocol::DatasegmentAdd.new(params).process(database.connection)
      end

      def drop
        database.connection.protocol::DatasegmentDrop.new(params).process(database.connection)
      end

      private

      def params
        { session: database.connection.session, name: name, location: location }
      end
    end
  end
end
