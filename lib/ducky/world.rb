require "ducky/rooms"

module Ducky

  class World
    def initialize
      @rooms = {
        [0, 0] => EntranceHall.new
      }
    end

    def room_at( location )
      @rooms[ location ]
    end
  end

end
