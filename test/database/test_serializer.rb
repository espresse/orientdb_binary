require 'minitest/spec'
require 'minitest/autorun'

describe OrientdbBinary::Serialization do

  describe 'Serialize' do
    before do
      @parser = OrientdbBinary::Serialization::Serialize.new
    end

    describe "parsing sets" do
      before do
        @should_be = "doc_with_set@a_set:<\"one\",\"two\",3,#12:1>"
        record = {
          :@class => "doc_with_set",
          a_set: Set.new(["one", "two", 3, "#12:1"])
        }
        @result = @parser.serialize_document(record)
      end

      it "should be Set" do
        assert_equal @result, @should_be
      end
    end
  end
end
