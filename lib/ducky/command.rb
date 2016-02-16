module Ducky

  # A class to store the information of user commands
  # A valid command can be:
  #   A verb
  #   A verb and a noun
  #   A verb, a noun, and prepositional phrase
  # In a prepositional phrase:
  #   the preposition is always 'with'
  #   the prepositional object is stored in @obect
  #
  # Examples of valid phrases:
  #   inventory
  #   quit
  #   take rope
  #   look at gem
  #   climb down hole with rope
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
