module OrientdbBinary
  module Protocols
    class DbRelease < BinData::Record
      include OrientdbBinary::Protocols::Base

      endian :big

      int8 :operation, value: OrientdbBinary::OperationTypes::REQUEST_DB_RELEASE
      int32 :session

      protocol_string :name
      protocol_string :storage
    end

    class DbReleaseAnswer < BinData::Record
      endian :big

      int32 :session
    end
  end
end
