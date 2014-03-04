module Orientdb
  class RecordId
    attr_accessor :cluster, :position

    alias_method :eql?, :==

    def initialize(rid=nil)
      @cluster = nil
      @position = nil
      if rid.is_a? String and not rid.empty?
        parse_rid(rid)
      elsif rid.is_a? Orientdb::RecordId
        @cluster = rid.cluster
        @position = rid.position
      end
    end

    def parse_rid(rid)
      match = rid.match(/^[#]?(?<cluster>-?\d+):(?<position>-?\d+)$/)
      @cluster = match[:cluster].to_i
      @position = match[:position].to_i
      self
    end

    def to_s
      unless cluster && position
        "nil"
      else
        "##{cluster}:#{position}"
      end
    end

    def temporary?
      @cluster < 0
    end

    def ==(o)
      o.class == self.class && o.cluster == self.cluster && o.position == self.position
    end

  end
end
