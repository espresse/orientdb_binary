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
      @db.drop_datasegment(name: 'test_datasegment')
      assert @db.reload()[:clusters].last[:cluster_name] != 'testmemory'
    end

    it "should add datacluster" do
      @db.add_datasegment(name: 'test_datasegment', location: 'test_location')
      @db.add_datacluster(type: 'MEMORY', name: 'testmemory', location: 'test_location', datasegment_name: 'test_datasegment')
      assert @db.reload()[:clusters].last[:cluster_name] == "testmemory"
    end
  end  
end