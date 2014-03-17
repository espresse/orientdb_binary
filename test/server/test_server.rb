require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Server do
  describe "database management" do
    before do
      @server = TestHelper::Server.instance.server
      @exist = @server.database.new(name: '_test', storage: 'memory')

      unless @exist.exists?
        @exist.save!
      end

      @not_exist = @server.database.new(name: 'unknown', storage: :memory)
    end

    after do
      @exist.drop! if @exist.exists?
    end

    it "should check existance" do
      assert_equal false, @not_exist.exists?
    end

    it "should drop database" do
      @exist.drop!
      assert_equal false, @exist.exists?
    end

    it "should list databases" do
      list = @server.database.list
      assert list.length > 0
      assert_equal "memory:_test", list[:_test]
    end
  end

  describe "config management" do
    before do
      server = TestHelper::Server.instance.server
      @config = server.config
    end

    it "should get config value by key" do
      option = @config.list.last
      assert_equal @config.get(option[:config_key]), option[:config_value]
    end

    it "should set config value" do
      option = @config.list.last
      @config.set(option[:config_key], "150001")
      assert_equal @config.get(option[:config_key]), "150001"

      @config.set(option[:config_key], option[:config_value])
      assert_equal @config.get(option[:config_key]), option[:config_value]
    end

    it "should list all configs" do
      assert @config.list.length > 0
    end
  end
end
