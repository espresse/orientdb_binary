require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Database do
  before do
    @database = TestHelper::Database.instance.database
  end

  describe "basic operations" do
    it "should be opened" do
      assert @database.opened?
    end

    # it "should close database" do
    #   @database.close
    #   assert !@database.opened?
    #   @database.open
    #   assert @database.opened?
    # end

    it "should reload database" do
      assert @database.reload.clusters.length > 0
    end

    it "should return database size" do
      assert @database.size > 0
    end
  end
end

#   before do
#     @server = OrientdbBinary::Server.new(TestHelper::SERVER)
#     @server.connect(TestHelper::SERVER_USER)

#     if @server.db_exists? TestHelper::TEST_DB[:db]
#       @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
#     end
#     @server.db_create(TestHelper::TEST_DB[:db], 'document', TestHelper::TEST_DB[:storage])

#     @db = OrientdbBinary::Database.new(TestHelper::SERVER)
#     @open = @db.open(TestHelper::TEST_DB.merge(TestHelper::TEST_DB_USER))
#   end

#   after do
#     if @server.db_exists? TestHelper::TEST_DB[:db]
#       @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
#     end
#     @db.disconnect
#     assert !@db.connected?
#     @server.disconnect
#   end

#   describe 'database' do
#     it "should be opened" do
#       assert @db.connected?
#     end

#     it "should have info about build" do
#       assert @open[:orientdb_release].length > 0
#     end

#     it "should count records" do
#       assert @db.count_records[:count_records] == 12 #(6 OIdentity + 3 OUser + 3 ORole)
#     end

#     it "should reload database" do
#       answer = @db.reload()
#       assert_equal answer[:num_of_clusters], answer[:clusters].length
#     end

#     it "should add datasegment" do
#       assert @db.add_datasegment(name: 'test_datasegment', location: 'test_location')[:segment_id] > 0
#     end

#     it "should add datasegment providing name only" do
#       assert @db.add_datasegment(name: 'test_datasegment_1')[:segment_id] > 0
#     end

#     it "should drop datasegment" do
#       @db.add_datasegment(name: 'test_datasegment', location: 'test_location')
#       assert @db.drop_datasegment(name: 'test_datasegment')[:succeed]
#     end

#     describe 'datacluster' do
#       before do
#         @db.add_datasegment(name: 'test_datasegment', location: 'test_location')
#         @datacluster = @db.add_datacluster(type: 'MEMORY', name: 'testmemory', location: 'test_location', datasegment_name: 'test_datasegment')
#       end

#       after do
#         @db.drop_datacluster(cluster_id: @datacluster[:cluster_id]) if @datacluster
#       end

#       it "should add" do
#         assert @db.reload()[:clusters].last[:cluster_name] == "testmemory"
#       end

#       it "should add datacluster without optional params" do
#         datacluster = @db.add_datacluster(name: 'test_cluster', datasegment_name: 'default')
#         assert @db.reload()[:clusters].last[:cluster_name] == "test_cluster"
#         @db.drop_datacluster(cluster_id: datacluster[:cluster_id])
#       end

#       it "should drop" do
#         @db.drop_datacluster(cluster_id: @datacluster[:cluster_id])
#         @db.reload()[:clusters]
#         assert @db.reload()[:clusters].last[:cluster_name] != "testmemory"
#         @datacluster = nil
#       end

#       it "should drop datacluster when providing name of it" do
#         @db.drop_datacluster(cluster_name: 'testmemory')
#       end

#       it "should count" do
#         assert_equal 6, @db.count_datacluster(cluster_ids: [0,1,2])[:records_in_clusters]
#       end

#       it "should count clusters by name" do
#         assert_equal 6, @db.count_datacluster(cluster_names: ['internal','index','manindex'])[:records_in_clusters]
#       end

#       it "should return datarange" do
#         range = @db.datarange_datacluster(cluster_id: 0)
#         assert_equal 0, range[:record_id_begin]
#         assert_equal 2, range[:record_id_end]
#       end

#       it "should return datarange" do
#         range = @db.datarange_datacluster(cluster_name: 'internal')
#         assert_equal 0, range[:record_id_begin]
#         assert_equal 2, range[:record_id_end]
#       end
#     end

#     describe "record" do
#       it "should be possible to add it" do
#         params = {
#           datasegment_id: -1,
#           cluster_id: 5,
#           record_content: "OUser@name:\"other_admin\",password:\"{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918\",status:\"ACTIVE\",roles:<#4:0>",
#           record_type: 100,
#           mode: 0
#         }
#         record = @db.create_record(params)
#         match = record[:@rid].match /#(?<version>\d+):(?<position>\d+)/
#         assert match[:position].to_i > 0
#       end

#       it "should be possible to add object with class" do
#         record = {
#           :@class => "OUser",
#           name: "other_admin",
#           password: "{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918",
#           status: "ACTIVE",
#           roles: (Set.new ["#4:0"])
#         }
#         record = @db.create_record_from_object(record)
#         match = record[:@rid].match /#(?<version>\d+):(?<position>\d+)/
#         assert match[:position].to_i == 3
#       end

#       it "should be possible to add object with cluster" do
#         record = {
#           :@class => "OUser",
#           :@cluster => "ouser",
#           name: "other_admin",
#           password: "{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918",
#           status: "ACTIVE",
#           roles: (Set.new ["#4:0"])
#         }
#         record = @db.create_record_from_object(record)
#         match = record[:@rid].match /#(?<version>\d+):(?<position>\d+)/
#         assert match[:position].to_i > 0
#       end

#       it "should be able to read content" do
#         record = @db.load_record(cluster_id: 5, cluster_position: 0, fetch_plan: "*:0", ignore_cache: 1, load_tombstones: 0)
#         assert record[:collection].length > 0
#       end

#       it "should be able to load record by providing rid only" do
#         record = @db.load_record(rid: "#5:0")
#         assert record[:collection].length > 0
#       end

#       it "should be able to pre-fetch linked collection" do
#         record = @db.load_record(cluster_id: 5, cluster_position: 0, fetch_plan: "*:-1", ignore_cache: 1, load_tombstones: 0)
#         assert_equal record[:prefetched_records].length, 1
#       end

#       it "should be able to update" do
#         params = {
#           cluster_id: 5,
#           cluster_position: 0,
#           record_content: "OUser@name:\"other_admin\",password:\"{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918\",status:\"ACTIVE\",roles:<#4:0>",
#           record_version: 0,
#           record_type: 100,
#           mode: 0
#         }
#         record = @db.update_record(params)
#         assert_equal record[:record_version], 1
#       end

#       describe "delete" do
#         before do
#           @delete_action = @db.delete_record(cluster_id: 5, cluster_position: 0, record_version: 0, mode: 0)
#         end
#         it "should hav epayload status set to 1" do
#           assert_equal 1, @delete_action[:payload_status]
#         end

#         it "should not load record" do
#            assert_equal 0, @db.load_record(cluster_id: 5, cluster_position: 0, fetch_plan: "*:-1", ignore_cache: 1, load_tombstones: 0)[:collection].length
#         end
#       end

#       describe "function" do
#         it "should be able to insert a function" do
#           record = @db.register_script(name: "test_script", code: "return 2;")
#           assert_equal "#7:0", record[:@rid]
#         end

#       end
#     end

#     describe "Queries" do

#       describe "Query" do
#         before do
#           @query = @db.query('SELECT FROM OUser where name = :name', {name: "admin"})
#         end

#         it "should find one data" do
#           assert_equal 1, @query[:collection].length
#         end

#         it "should be admin user" do
#           assert_equal 5, @query[:collection][0][:cluster_id]
#           assert_equal 0, @query[:collection][0][:position]
#         end
#       end

#       describe "Command" do
#         before do
#           @query = @db.command('INSERT INTO OUser (name, password, status) VALUES ("a", "secret", "ACTIVE"), ("b", "secret", "ACTIVE")', {})
#         end

#         it "should find one data" do
#           assert_equal 2, @query[:collection].length
#         end

#         it "should be user" do
#           user = OrientdbBinary::Parser::Deserializer.new.deserialize_document(@query[:collection][0][:record_content])
#           assert_equal "a", user[:name]
#         end
#       end

#       describe "Command returning one value" do
#         before do
#           @query = @db.command('INSERT INTO OUser (name, password, status) VALUES ("a", "secret", "ACTIVE")', {})
#         end

#         it "should find one data" do
#           assert_equal 1, @query[:collection].length
#         end

#         it "should be user" do
#           user = OrientdbBinary::Parser::Deserializer.new.deserialize_document(@query[:collection][0][:record_content])
#           assert_equal "a", user[:name]
#         end
#       end
#     end
#   end
# end
