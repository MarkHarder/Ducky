module Ducky

  class Player
    attr_accessor :location
    attr_reader :items

    def initialize
      @location = [0, 0, 0]
      @items = []
    end

    def go( direction )
      x = @location[0]
      y = @location[1]
      z = @location[2]

      relative_directions = {
        north: [x, y+1, z],
        south: [x, y-1, z],
        east: [x+1, y, z],
        west: [x-1, y, z],
      }

      if relative_directions.has_key?( direction )
        coord = relative_directions[ direction ]

        if WORLD.room_exists?( coord )
          puts "You go #{direction}."
          @location = coord
          puts WORLD.room_at( @location ).description
        else
          puts "You can't go that direction."
        end
      end
    end
  end

end
