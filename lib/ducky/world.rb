require "ducky/coordinate"
require "ducky/rooms"

module Ducky

  class World
    attr_accessor :key_found
    attr_reader :stairs

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

    def room_description( location )
      description = room_at( location ).description + "\n"

      item_names =  room_at( location ).items.collect { |i| i.name }
      if item_names.length > 0
        description += "You can see: #{ item_names.join( ", " ) }\n"
      end

      description += "You can go: " + exits_at( location ).join( ", " )

      description
    end
  end

end
