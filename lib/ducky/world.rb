require "ducky/coordinate"
require "ducky/rooms"

module Ducky

  # The world class, which tracks all the rooms, walls, and stairs
  # it also knows if the exit key has been found or not
  #   @rooms are all the locations in the game
  #   @walls are the walls used to calculate a room's exits
  #   @stairs are the stairs used to calculate a room's exits
  #   @key_found is true if the exit key has been found, false if not
  class World
    attr_accessor :key_found
    attr_reader :stairs

    # set up all the rooms at their starting locations
    # place all the walls and stairs
    #   walls and stairs are one way
    #   if you want to prevent movement in both directions:
    #     put a wall in both rooms in the direction the player shouldn't move
    def initialize
      @rooms = {
        Coordinate.new(2, 1, -1) => DungeonCellRoom.new,
        Coordinate.new(2, 2, -1) => DungeonRoom.new,

        Coordinate.new(-2, 2, 0) => RugRoom.new,
        Coordinate.new(-1, 1, 0) => RopeRoom.new,
        Coordinate.new(-1, 2, 0) => FootStatueRoom.new,
        Coordinate.new(0, 0, 0) => EntranceHall.new,
        Coordinate.new(0, 1, 0) => VendingMachineRoom.new,
        Coordinate.new(1, 1, 0) => TowelRoom.new,
        Coordinate.new(1, 2, 0) => BaseballRoom.new,
        Coordinate.new(2, 0, 0) => BrainRoom.new,
        Coordinate.new(2, 1, 0) => HoleRoom.new,
        Coordinate.new(2, 2, 0) => DungeonStairsRoom.new,
        Coordinate.new(2, 3, 0) => GemRoom.new,
        Coordinate.new(3, 2, 0) => NecklaceRoom.new,
      }

      @walls = {
        Coordinate.new(2, 1, -1) => [ :north ],
        Coordinate.new(2, 2, -1) => [ :south ],

        Coordinate.new(2, 1, 0) => [ :north ],
        Coordinate.new(2, 2, 0) => [ :south ],
      }

      @stairs = {
        Coordinate.new(2, 2, 0) => [ :down ],
        Coordinate.new(2, 2, -1) => [ :up ],
      }

      @key_found = false
    end

    # check the exits at a location
    #   add existing rooms to the north, south, east, and west
    #   but don't add rooms when there are walls in that direction
    #   add up or down directions if there are stairs
    def exits_at( location )
      exits = []

      # check that a room exists at the given location
      if room_exists?( location )
        directions = %i( north south east west )

        # check north, south, east, and west accounting for walls
        for direction in directions
          target_coordinate = location.send( direction )
          if room_exists?( target_coordinate ) && !@walls[ location ]&.include?( direction )
            exits.push( direction )
          end
        end

        # add up and down if needed
        if @stairs[ location ]&.include?( :down )
          exits.push( :down )
        elsif @stairs[ location ]&.include?( :up )
          exits.push( :up )
        end
      end

      exits
    end

    # get the room at a location
    def room_at( location )
      @rooms[ location ]
    end

    # check if a room exists
    def room_exists?( location )
      !room_at( location ).nil?
    end

    # get the full description of a room
    #   first is the description of the room contents
    #   second are the items in the room if there are any
    #   third are the the exits
    def room_description( location )
      description = room_at( location ).description + "\n"

      item_names =  room_at( location ).items.collect { |i| i.name }
      if item_names.length > 0
        description += "You can see: #{ item_names.join( ", " ) }\n"
      end

      description += "You can go: " + exits_at( location ).join( ", " )
    end
  end

end
