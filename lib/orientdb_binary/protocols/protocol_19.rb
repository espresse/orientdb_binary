require_relative 'base/bindata_primitives'
require_relative 'base/base'
require_relative 'base/errors'

# server
require_relative 'base/connect'
require_relative 'base/shutdown'
require_relative 'base/config_list'
require_relative 'base/config_get'
require_relative 'base/config_set'
require_relative 'base/db_list'
require_relative 'base/db_exist'
require_relative 'base/db_create'
require_relative 'base/db_drop'
require_relative 'base/db_freeze'
require_relative 'base/db_release'

# database

require_relative 'base/db_close'
require_relative 'base/db_open'
require_relative 'base/db_reload'
require_relative 'base/db_size'
require_relative 'base/db_list'


module OrientdbBinary
  module Protocol
    class Protocol19
      #server
      include BaseProtocol
    end
  end
end
