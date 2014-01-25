module OrientdbBinary
  module Protocols

    module Base

      def process(socket)
        write(socket)

        status = BinData::Int8.read(socket).to_i
        process_errors(status)

        constantize("#{self.class.to_s}Answer").read(socket)
      end

      private

      def process_errors(status)
        if status == 1
          errors = OrientdbBinary::Protocols::Errors.read(socket)
          raise ProtocolError.new(self.session, *errors[:exceptions][0]) if errors[:exceptions].length > 0
        end
      end

      # this might go to String (as a refinment?)
      def constantize(name)
        names = name.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant

      end
    end
  end
end
