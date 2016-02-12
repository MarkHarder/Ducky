require "ducky/rooms"

module Ducky

  class World
    def initialize
      @rooms = {
        [2, 1, -1] => DungeonCellRoom.new,
        [2, 2, -1] => DungeonRoom.new,

        [-2, 2, 0] => RugRoom.new,
        [-1, 1, 0] => RopeRoom.new,
        [-1, 2, 0] => FootStatueRoom.new,
        [0, 0, 0] => EntranceHall.new,
        [0, 1, 0] => VendingMachineRoom.new,
        [1, 1, 0] => TowelRoom.new,
        [1, 2, 0] => BaseballRoom.new,
        [2, 0, 0] => BrainRoom.new,
        [2, 1, 0] => HoleRoom.new,
        [2, 2, 0] => DungeonStairsRoom.new,
        [2, 3, 0] => GemRoom.new,
        [3, 2, 0] => NecklaceRoom.new,
      }
    end

    def room_at( location )
      @rooms[ location ]
    end

    def room_exists?( location )
      !room_at( location ).nil?
    end
  end

end
