require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Server do
  before do
    @server = OrientdbBinary::Server.new(TestHelper::SERVER)
    @server.connect(TestHelper::SERVER_USER)
  end

  after do
    @server.disconnect
  end

  describe "connection" do
    it "should set session" do
      assert @server.session > -1
    end

    it "should be connected" do
      assert @server.connected?
    end

    it "should return socket" do
      assert_instance_of TCPSocket, @server.socket
    end
  end

  describe "configuration" do
    it "should list configuration options" do
      assert @server.config_list[:config_list].length > 0
    end

    it "should get configuration option" do
      option = @server.config_list[:config_list].last
      assert_equal @server.get_config(option[:option_key])[:option_value], option[:option_value]
    end

    it "should set configuration option" do
      option = @server.config_list[:config_list].last
      new_value = "15001"
      @server.set_config(option[:option_key], new_value)
      assert_equal @server.get_config(option[:option_key])[:option_value], new_value
      # set it back
      @server.set_config(option[:option_key], option[:option_value])
      assert_equal @server.get_config(option[:option_key])[:option_value], option[:option_value]
    end
  end

  describe "database" do
    before do
      if @server.db_exists? TestHelper::TEST_DB[:db]
        @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
      end
      assert(!@server.db_exists?(TestHelper::TEST_DB[:db]))
    end

    after do
      if @server.db_exists? TestHelper::TEST_DB[:db]
        @server.db_drop TestHelper::TEST_DB[:db], TestHelper::TEST_DB[:storage]
      end
      assert(!@server.db_exists?(TestHelper::TEST_DB[:db]))
    end

    it "should create database" do
      @server.db_create(TestHelper::TEST_DB[:db], 'document', TestHelper::TEST_DB[:storage])
      assert @server.db_exists? TestHelper::TEST_DB[:db]
    end

    it "should list databases" do
      assert @server.list[:databases].has_key?(:GratefulDeadConcerts)
    end
  end
end
