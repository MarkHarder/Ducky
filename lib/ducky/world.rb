require "ducky/coordinate"
require "ducky/rooms"
require "ducky/terminal_utilities"

module Ducky

  class World
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
    end

    def exits_at( location )
      exits = []

      if room_exists?( location )
        directions = %i( north south east west )

        for direction in directions
          target_coordinate = location.send( direction )
          if room_exists?( target_coordinate ) && !@walls[ location ]&.include?( direction )
            exits.push( direction )
          end
        end

        if @stairs[ location ]&.include?( :down )
            exits.push( :down )
        elsif @stairs[ location ]&.include?( :up )
            exits.push( :up )
        end
      end

      exits
    end

    def room_at( location )
      @rooms[ location ]
    end

    def room_exists?( location )
      !room_at( location ).nil?
    end

    def describe_room( location )
      puts TerminalUtilities.format( room_at( location ).description )

      item_names =  room_at( location ).items.collect { |i| i.name }
      if item_names.length > 0
        puts TerminalUtilities.format( "You can see: #{ item_names.join( ", " ) }" )
      end

      puts "You can go: " + exits_at( location ).join( ", " )
    end
  end

end
