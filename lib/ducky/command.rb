module Ducky

  class Command
    attr_reader :verb, :noun, :prepositional_phrase

    def initialize( verb, noun=nil, prepositional_phrase=nil )
      @verb = verb
      @noun = noun
      @prepositional_phrase = prepositional_phrase
    end

    def to_s
      if @prepositional_phrase
        "#{@verb} #{@noun} #{@prepositional_phrase}"
      elsif @noun
        "#{@verb} #{@noun}"
      else
        "#{@verb}"
      end
    end

  end
end
