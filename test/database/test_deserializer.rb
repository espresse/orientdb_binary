# require 'minitest/spec'
# require 'minitest/autorun'

# describe OrientdbBinary::Parser do

#   describe 'Deserializer' do
#     before do
#       @parser = OrientdbBinary::Parser::Deserializer.new
#     end

#     describe "parsing sets" do
#       before do
#         record = "DocWithSets@a_set:<\"one\",\"two\",3,#12:1>"
#         @result = @parser.deserialize_document(record)
#       end

#       it "should be Set" do
#         assert_equal @result[:a_set].class, Set
#       end

#       it "should find 4 elements" do
#         assert_equal @result[:a_set].length, 4
#       end

#       it "should parse string in set" do
#         assert @result[:a_set].include? "one"
#       end

#       it "should parse integer in set" do
#         assert @result[:a_set].include? 3
#       end

#       it "should parse rid in set" do
#         assert_equal Orientdb::RecordId.new('#12:1'), @result[:a_set].to_a.last
#       end
#     end

#     describe "parsing primitives" do
#       before do
#         record = "@date:#{Date.today.to_datetime.to_time.to_i}a,time:#{DateTime.now.to_time.to_i}t,name:\"HEY BO DIDDLEY\",song_type:\"cover\",is_active:true,performances:5,stars:5.234f,price:12c,type:\"song\",out_followed_by:<#11:0,#11:1,#11:2,#11:3,#11:4>,out_written_by:#9:7,out_sung_by:#9:8,in_followed_by:<#11:10,#11:150,#11:2578,#11:5574>                                                                                                                                                                                                           "
#         @result = @parser.deserialize_document(record)
#       end

#       it "should parse string as String" do
#         assert @result[:name].is_a? String
#       end

#       it "should parse string" do
#         assert_equal @result[:name], "HEY BO DIDDLEY"
#       end

#       it "should parse int as integer" do
#         assert_equal @result[:performances], 5
#       end

#       it "should parse date" do
#         assert @result[:date].is_a? Date
#       end

#       it "should parse datetime" do
#         assert @result[:time].is_a? DateTime
#       end

#       it "should parse float" do
#         assert @result[:stars].is_a? Float
#       end

#       it "should parse big decimals" do
#         assert @result[:price].is_a? BigDecimal
#       end

#       it "should parse booleans" do
#         assert @result[:is_active].is_a? TrueClass
#       end
#     end

#     describe "parsing hashes" do
#       before do
#         record = "Hash@html:{\"path\":\"html/layout\"}"
#         @result = @parser.deserialize_document(record)
#       end

#       it "should parse hash as Hash" do
#         assert @result.is_a? Hash
#       end

#       it "should parse hash parameters" do
#         assert_equal @result[:html][:path], "html/layout"
#       end
#     end

#     describe "parsing arrays" do
#       before do
#         record = "Array@array:[\"path\",{hash:{path:\"html/layout\"}},2]"
#         @result = @parser.deserialize_document(record)
#       end

#       it "should parse array" do
#         assert @result[:array].is_a? Array
#       end

#       it "should find 3 elements" do
#         assert_equal @result[:array].length, 3
#       end

#       describe "array elements" do
#         it "should parse string" do
#           assert_equal @result[:array][0], "path"
#         end

#         it "should parse hash" do
#           assert @result[:array][1].is_a? Hash
#         end

#         it "should parse integers" do
#           assert @result[:array][2].is_a? Integer
#         end
#       end
#     end

#     describe "parsing documents" do
#       before do
#         record = "schemaVersion:4,classes:[(name:\"OUser\",shortName:,defaultClusterId:4,clusterIds:[4],overSize:0.0f,strictMode:false,properties:[(name:\"password\",type:7,mandatory:true,notNull:true,min:,max:,regexp:,linkedClass:,linkedType:),(name:\"name\",type:7,mandatory:true,notNull:true,min:,max:,regexp:,linkedClass:,linkedType:),(name:\"roles\",type:15,mandatory:false,notNull:false,min:,max:,regexp:,linkedClass:\"ORole\",linkedType:)]),(name:\"ORole\",shortName:,defaultClusterId:3,clusterIds:[3],overSize:0.0f,strictMode:false,properties:[(name:\"mode\",type:17,mandatory:false,notNull:false,min:,max:,regexp:,linkedClass:,linkedType:),(name:\"rules\",type:12,mandatory:false,notNull:false,min:,max:,regexp:,linkedClass:,linkedType:17),(name:\"name\",type:7,mandatory:true,notNull:true,min:,max:,regexp:,linkedClass:,linkedType:)])]"
#         @result = @parser.deserialize_document(record)
#       end

#       it "should parse documents" do
#         assert @result[:classes][0][:@type], "d"
#       end

#       it "should parse embedded documents" do
#         assert @result[:classes][0][:properties][0][:@type], "d"
#       end

#       it "should parse empty objects" do
#         assert_equal @result[:classes][0][:properties][0][:max], nil
#       end
#     end
#   end
# end
