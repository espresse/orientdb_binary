require 'orientdb_binary'
srv = {host: 'localhost', port: 2424}
server = OrientdbBinary::Server.new(srv)
server.connect(user: 'root', password: 'root')
server.db_create('testowo1', 'document', 'memory')
# config_list = server.config_list()['config_list']
# elem = config_list.last
# p elem, elem['option_key']
# p server.get_config('distributed.purgeResponsesTimerDelay')
# server.set_config('distributed.purgeResponsesTimerDelay', 15001)
# p server.get_config('distributed.purgeResponsesTimerDelay')
# server.set_config('distributed.purgeResponsesTimerDelay', 15000)
# p server.get_config('distributed.purgeResponsesTimerDelay')
server.disconnect()

dtb = {host: 'localhost', port: 2424}
database = OrientdbBinary::Database.new(dtb)
database.open(db: 'testowo', user: "admin", password: "admin")
# p database.query('select expand(set(in("sung_by").out("written_by"))) from #9:8', {artist: 'artist'})
p database.count_records
# p database.load_record(9, 0, '', 1, 0)

