require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Database do
  before do
    @server = OrientdbBinary::Server.new(TestHelper::SERVER)
    @server.connect(TestHelper::SERVER_USER)

    if @server.db_exists? TestHelper::TEST_DB[:db]
      @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
    end
    @server.db_create(TestHelper::TEST_DB[:db], 'document', TestHelper::TEST_DB[:storage])

    @db = OrientdbBinary::Database.new(TestHelper::SERVER)
    @open = @db.open(TestHelper::TEST_DB.merge(TestHelper::TEST_DB_USER))
  end

  after do
    if @server.db_exists? TestHelper::TEST_DB[:db]
      @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
    end
    @db.disconnect
    assert !@db.connected?
    @server.disconnect
  end

  describe 'database' do
    it "should be opened" do
      assert @db.connected?
    end

    it "should have info about build" do
      assert @open[:orientdb_release].length > 0
    end

    it "should count records" do
      assert @db.count_records[:count_records] == 12 #(6 OIdentity + 3 OUser + 3 ORole)
    end

    it "should reload database" do
      answer = @db.reload()
      assert_equal answer[:num_of_clusters], answer[:clusters].length
    end

    it "should add datasegment" do
      assert @db.add_datasegment(name: 'test_datasegment', location: 'test_location')[:segment_id] > 0
    end

    it "should drop datasegment" do
      @db.add_datasegment(name: 'test_datasegment', location: 'test_location')
      assert @db.drop_datasegment(name: 'test_datasegment')[:succeed]
    end

    describe 'datacluster' do
      before do
        @db.add_datasegment(name: 'test_datasegment', location: 'test_location')
        @datacluster = @db.add_datacluster(type: 'MEMORY', name: 'testmemory', location: 'test_location', datasegment_name: 'test_datasegment')
      end

      after do
        @db.drop_datacluster(cluster_id: @datacluster[:cluster_id]) if @datacluster
      end

      it "should add" do
        assert @db.reload()[:clusters].last[:cluster_name] == "testmemory"
      end

      it "should drop" do
        @db.drop_datacluster(cluster_id: @datacluster[:cluster_id])
        @db.reload()[:clusters]
        assert @db.reload()[:clusters].last[:cluster_name] != "testmemory"
        @datacluster = nil
      end

      it "should count" do
        assert_equal 6, @db.count_datacluster(cluster_count: 3, clusters: [0,1,2])[:records_in_clusters]
      end

      it "should return datarange" do
        assert_equal 0, @db.datarange_datacluster(cluster_id: 0)[:record_id_begin]
        assert_equal 2, @db.datarange_datacluster(cluster_id: 0)[:record_id_end]
      end
    end

    describe "record" do
      it "should be possible to add it" do
        params = {
          datasegment_id: -1,
          cluster_id: 5,
          record_content: "OUser@name:\"other_admin\",password:\"{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918\",status:\"ACTIVE\",roles:<#4:0>",
          record_type: 100,
          mode: 0
        }
        record = @db.create_record(params)
        assert record[:cluster_position].to_i > 0
      end

      it "should be able to read content" do
        record = @db.load_record(cluster_id: 5, cluster_position: 0, fetch_plan: "*:0", ignore_cache: 1, load_tombstones: 0)
        assert_equal record[:payload_status], 1
        assert !!record[:collection]
      end

      it "should be able to pre-fetch linked collection" do
        record = @db.load_record(cluster_id: 5, cluster_position: 0, fetch_plan: "*:-1", ignore_cache: 1, load_tombstones: 0)
        assert_equal record[:prefetched_records].length, 2
        assert !!record[:prefetched_records][0][:record_content]
      end

      it "should be able to update" do
        params = {
          cluster_id: 5,
          cluster_position: 0,
          record_content: "OUser@name:\"other_admin\",password:\"{SHA-256}8C6976E5B5410415BDE908BD4DEE15DFB167A9C873FC4BB8A81F6F2AB448A918\",status:\"ACTIVE\",roles:<#4:0>",
          record_version: 0,
          record_type: 100,
          mode: 0
        }
        record = @db.update_record(params)
        assert_equal record[:record_version], 1
      end

    end
  end
end
