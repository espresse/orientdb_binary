# require 'minitest/spec'
# require 'minitest/autorun'

# describe OrientdbBinary::Parser do

#   describe 'Serializer' do
#     before do
#       @parser = OrientdbBinary::Parser::Serializer.new
#     end

#     describe "parsing sets" do
#       before do
#         @should_be = "doc_with_set@a_set:<\"one\",\"two\",3,#12:1>"
#         record = {
#           :@class => "doc_with_set",
#           a_set: Set.new(["one", "two", 3, "#12:1"])
#         }
#         @result = @parser.serialize_document(record)
#       end

#       it "should be set" do
#         assert_equal @result, @should_be
#       end
#     end

#     describe "parsing arrays" do
#       before do
#         @should_be = "doc_with_array@an_array:[\"one\",\"two\",3,#12:1]"
#         record = {
#           :@class => "doc_with_array",
#           an_array: ["one", "two", 3, "#12:1"]
#         }
#         @result = @parser.serialize_document(record)
#       end

#       it "should be array" do
#         assert_equal @result, @should_be
#       end
#     end

#     describe "parsing hashes" do
#       before do
#         @should_be = "a_hash:{one:1,two:\"two\"}"
#         record = {
#           a_hash: {one: 1, two: "two"}
#         }
#         @result = @parser.serialize_document(record)
#       end

#       it "should be hash" do
#         assert_equal @result, @should_be
#       end
#     end
#   end
# end
