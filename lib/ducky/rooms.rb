module Ducky

  class Room
    attr_reader :description

    def initialize( description )
      @description = description
    end
  end

  class EntranceHall < Room
    def initialize
      super( "You are standing in the entrance." )
    end
  end

end
