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
    @db.open(TestHelper::TEST_DB.merge(TestHelper::TEST_DB_USER))
  end

  after do
    if @server.db_exists? TestHelper::TEST_DB[:db]
      @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
    end
    @server.disconnect

    @db.disconnect
  end

  describe 'database' do
    it "should be opened" do
      assert @db.connected?
    end
  end  
end