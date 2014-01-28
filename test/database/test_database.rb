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
  end
end
