require 'minitest/spec'
require 'minitest/autorun'

# SimpleCov.command_name 'test:server'

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

  describe "config" do
    it "should list configuration options" do
      assert @server.config_list[:config_list].length > 0
    end

    it "should get configuration option" do
      option = @server.config_list[:config_list].last
      assert_equal @server.get_config(option[:option_key])[:option_value], option[:option_value]
    end
  end
end