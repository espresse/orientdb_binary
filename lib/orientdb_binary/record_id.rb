module Orientdb
  class RecordId
    attr_reader :cluster, :position

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

    def empty?
      !(cluster && position)
    end

    def inspect
      return "#<#{self.class.name}:#{self.object_id} cluster: #{cluster} position: #{position}>"
    end

    def to_id
      empty? ? nil : "#{cluster}:#{position}"
    end

    def to_s
      empty? ? nil : "##{cluster}:#{position}"
    end

    def as_json(**args)
      to_s
    end

    def temporary?
      cluster < 0
    end

    def ==(o)
      o.class == self.class && o.cluster == self.cluster && o.position == self.position
    end

  end
end
