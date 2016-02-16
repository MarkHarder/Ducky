module Ducky

  class Command
    attr_reader :verb, :noun, :object

    def initialize( verb, noun=nil, object=nil )
      @verb = verb
      @noun = noun
      @object = object
    end

    def to_s
      if @object
        "#{@verb} #{@noun} with #{@object}"
      elsif @noun
        "#{@verb} #{@noun}"
      else
        "#{@verb}"
      end
    end

  end
end
