module OrientdbBinary
  class Database
    class Segment
      attr_reader :name, :location, :database

      # Initialize connection to segments
      #
      # @since 1.0
      def self.initialize_with(database)
        Segment.new(database)
      end

      # Initialize connection to segments
      #
      # @since 1.0
      def initialize(database)
        @database = database
      end

      # Initialize segment params
      #
      # @param [String, Symbol] name
      # @param [String, Symbol] location, optional
      #
      # @since 1.0
      def new(name:, location: nil)
        @name = name.to_s
        @location = location || @name + "_segments"
        self
      end

      # Creates data segment with provided name and location
      #
      # @return [Integer] segment id
      #
      # @since 1.0
      def create!
        database.connection.protocol::DatasegmentAdd.new(params).process(database.connection)[:segment_id]
      end

      # Removes data segment by its name
      #
      # @return [True, False] True if succeed, false if not
      #
      # @since 1.0
      def drop!
        answer = database.connection.protocol::DatasegmentDrop.new(params).process(database.connection)
        answer[:succeed] == 1
      end

      private

      # Creates params from data
      #
      # @api private
      #
      # @since 1.0
      def params
        { session: database.connection.session, name: name, location: location }
      end
    end
  end
end
