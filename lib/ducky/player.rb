require "ducky/coordinate"
require "ducky/terminal_utilities"

module Ducky

  class Player
    attr_accessor :location
    attr_reader :items

    def initialize
      @location = Coordinate.new(0, 0, 0)
      @items = []
      @visited_locations = [ Coordinate.new(0, 0, 0) ]
    end

    def go( direction )
      exits = WORLD.exits_at( @location )

      if exits.include?( direction )
        puts TerminalUtilities.format( "You go #{ direction.to_s }." )
        @location = @location.send( direction )
        unless @visited_locations.include?( @location )
          @visited_locations.push( @location )
          if @visited_locations.length == 13 && !WORLD.key_found
            WORLD.key_found = true
            WORLD.room_at( @location ).items.push( Key.new )
          end
        end
        puts TerminalUtilities.format( WORLD.room_description( @location ) )
      else
        puts TerminalUtilities.format( "You can't go that direction." )
      end
    end

    def take( item )
      @items.push( item )

      if @items.length == 6 && !WORLD.key_found
        WORLD.key_found = true
        puts TerminalUtilities.format( "You find a key and take that too." )
        @items.push( Key.new )
      end
    end

    def find_item( item_name )
      for item in @items
        if item.name == item_name
          return item
        end
      end

      nil
    end
  end

end
