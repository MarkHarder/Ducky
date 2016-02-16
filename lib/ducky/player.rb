require "ducky/coordinate"
require "ducky/terminal_utilities"

module Ducky

  # The class that stores all the information related to the player
  #   @location is the player's current location in xyz coordinates
  #   @items is the collection of items the player has in their possession
  #   @visited_locations is a list of all the unique rooms the player has been in
  class Player
    attr_reader :location, :items

    def initialize
      @location = Coordinate.new(0, 0, 0)
      @items = []
      @visited_locations = [ Coordinate.new(0, 0, 0) ]
    end

    # try to move in the provided direction
    #   if there is a wall in the way, no staircase, or no room:
    #     the player stays where they are
    #     an error message is displayed
    #   otherwise the player moves to the new location
    def go( direction )
      # exits include all walls, stairs, and existing rooms
      exits = WORLD.exits_at( @location )

      # check there is an exit in the provided direction
      if exits.include?( direction )
        puts TerminalUtilities.format( "You go #{ direction.to_s }." )

        @location = @location.send( direction )

        # if the new location has not been visited
        #   add it to the visited list
        #   if 13 rooms have been visited
        #     add a key to the room
        #     flag that the key has been found
        unless @visited_locations.include?( @location )
          @visited_locations.push( @location )
          if @visited_locations.length == 13 && !WORLD.key_found
            WORLD.key_found = true
            WORLD.room_at( @location ).items.push( Key.new )
          end
        end

        # print the description of the new room
        puts TerminalUtilities.format( WORLD.room_description( @location ) )
      else
        puts TerminalUtilities.format( "You can't go that direction." )
      end
    end

    # add an item to the player's inventory
    # if the player then has 6 items in their possession:
    #   add a key to their items
    #   flag that the key has been found
    def take( item )
      @items.push( item )

      if @items.length == 6 && !WORLD.key_found
        WORLD.key_found = true
        puts TerminalUtilities.format( "You find a key and take that too." )
        @items.push( Key.new )
      end
    end

    # check to see if the player has an item with the provided name
    #   if they do, return it
    #   if they don't, return nil
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
