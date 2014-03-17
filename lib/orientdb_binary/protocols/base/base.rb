module OrientdbBinary
  module BaseProtocol

    module Base

      def process(connection)
        socket = connection.socket

        write(socket)
        status = BinData::Int8.read(socket).to_i
        errors = process_errors(socket, status)
        unless errors
          constantize("#{self.class.to_s}Answer").read(socket)
        else
          return {exceptions: errors[:exceptions][0..-2]}
        end
      end

      private

      def process_errors(socket, status)
        if status == 1
          errors = OrientdbBinary::Protocols::Errors.read(socket)
          return errors
        end
        return nil
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
