require 'orientdb_binary/database_operations/base_operations'
require 'orientdb_binary/database_operations/data_segment'
require 'orientdb_binary/database_operations/data_cluster'
require 'orientdb_binary/database_operations/record'
require 'orientdb_binary/database_operations/query'
require 'orientdb_binary/database_operations/transaction'

module OrientdbBinary
  class Database < OrientdbBinary::OrientdbBase
    include OrientdbBinary::DatabaseOperations::BaseOperations
    include OrientdbBinary::DatabaseOperations::DataSegment
    include OrientdbBinary::DatabaseOperations::DataCluster
    include OrientdbBinary::DatabaseOperations::Record
    include OrientdbBinary::DatabaseOperations::Query
    include OrientdbBinary::DatabaseOperations::Transaction

    attr_accessor :clusters

    def self.connect(options)
      Database.new(options)
    end

  end
end
