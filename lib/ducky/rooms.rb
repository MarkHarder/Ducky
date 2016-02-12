module Ducky

  class Room
    attr_reader :description

    def initialize( description )
      @description = description
    end
  end
  
  class DungeonCellRoom < Room
    def initialize
      super( "You see a white skeleton and a pile of straw." )
    end
  end

  class DungeonRoom < Room
    def initialize
      super( "You see a white skeleton through the bars of a cell." )
    end
  end

  class RugRoom < Room
    def initialize
      super( "A thick, red rug strikes a bold difference to the cream-colored walls." )
    end
  end

  class RopeRoom < Room
    def initialize
      super( "A rope is coiled onto the linoleum floor." )
    end
  end

  class FootStatueRoom < Room
    def initialize
      super( "The only thing in this room is a large, alabaster statue of a foot." )
    end
  end

  class EntranceHall < Room
    def initialize
      super( "You are standing in a room with white walls and a single black door." )
    end
  end

  class VendingMachineRoom < Room
    def initialize
      super( "The walls of this room are white and a large, purple vending machine stands against one wall." )
    end
  end

  class TowelRoom < Room
    def initialize
      super( "A stack of fluffy, yellow towels are sitting on a wooden cabinet." )
    end
  end

  class BaseballRoom < Room
    def initialize
      super( "The walls are blue here and a baseball hat lies folded on the floor." )
    end
  end

  class BrainRoom < Room
    def initialize
      super( "Resting on a pedestal is a brain in a jar." )
    end
  end

  class HoleRoom < Room
    def initialize
      super( "There is a large hole in the wooden floor of this room." )
    end
  end

  class DungeonStairsRoom < Room
    def initialize
      super( "The walls and floor of this room are stone and a narrow stone staircase leads down." )
    end
  end

  class GemRoom < Room
    def initialize
      super( "There is a gem on a pedestal here." )
    end
  end

  class NecklaceRoom < Room
    def initialize
      super( "A small wooden box has been left on the floor." )
    end
  end

end
