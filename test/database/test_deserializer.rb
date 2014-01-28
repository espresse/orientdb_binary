require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Serialization do

  describe 'Deserialize' do
    before do
      @parser = OrientdbBinary::Serialization::Deserialize.new
    end

    describe "parsing sets" do
      before do
        record = "@name:\"HEY BO DIDDLEY\",song_type:\"cover\",performances:5,type:\"song\",out_followed_by:<#11:0,#11:1,#11:2,#11:3,#11:4>,out_written_by:#9:7,out_sung_by:#9:8,in_followed_by:<#11:10,#11:150,#11:2578,#11:5574>                                                                                                                                                                                                           "
        @parser.deserialize_document(record)
      end

      it "should parse name" do
        assert_equal @parser.record[:name], "HEY BO DIDDLEY"
      end

      it "should parse sets" do
        assert_equal @parser.record[:out_followed_by].class, Set
      end

      it "should parse integer" do
        assert_equal @parser.record[:performances], 5
      end
    end
  end
end
