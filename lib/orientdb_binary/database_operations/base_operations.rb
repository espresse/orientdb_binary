# require 'orientdb_binary/protocols/db_close'
# require 'orientdb_binary/protocols/db_open'
# require 'orientdb_binary/protocols/db_reload'
# require 'orientdb_binary/protocols/db_size'
# require 'orientdb_binary/protocols/db_list'

# module OrientdbBinary
#   module DatabaseOperations
#     module BaseOperations

#       # Open database connection.
#       # Params:
#       # db: string -> database name
#       # user: username for accessing database
#       # password: user's pasword for database access
#       # storage: string -> memory, local, plocal; plocal is used by default
#       # Usage:
#       # db = OrientdbBinary::Database.open(db: "test", storage: 'plocal', user: 'admin', password: 'admin')
#       #
#       def open(args)
#         @db_params = {
#           db: args[:db],
#           storage: args[:storage]
#         }

#         defaults = {
#           storage: 'plocal'
#         }


#         connection = OrientdbBinary::Protocols::DbOpen.new(defaults.merge(args)).process(socket)

#         @session = connection[:session]
#         @connected = true if @session >= 0
#         @clusters = connection[:clusters]
#         connection
#       end

#       # Close databse connection
#       # No params are accepted
#       # Usage:
#       # db.close()
#       #
#       def close
#         OrientdbBinary::Protocols::DbClose.new(params).process(socket)
#         super
#       end

#       # Reload database. Information about clusters are updated
#       # No params are accepted
#       # Usage
#       # db.reload()
#       #
#       def reload
#         answer = OrientdbBinary::Protocols::DbReload.new(params).process(socket)
#         @clusters = answer[:clusters]
#         answer
#       end

#       # Return size of the database
#       # No params are accepted
#       # Usage:
#       # db.size()
#       #
#       def size
#         OrientdbBinary::Protocols::DbSize.new(params).process(socket)
#       end
#     end
#   end
# end
