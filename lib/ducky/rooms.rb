require "ducky/items"

module Ducky

  class Room
    attr_reader :description, :items

    def initialize( description )
      @description = description
      @items = []
    end

    def perform( command )
      if command.start_with?( "take" )
        item_name = command[5..-1]
        for item in @items
          if item.name == item_name
            puts "You take the #{ item_name }."
            taken_item = item
          end
        end

        unless taken_item.nil?
          @items.delete( taken_item )
          PLAYER.items.push( taken_item )
        end
      elsif command.start_with?( "drop" )
        item_name = command[5..-1]
        for item in PLAYER.items
          if item.name == item_name
            puts "You drop the #{ item_name }."
            dropped_item = item
          end
        end

        unless dropped_item.nil?
          PLAYER.items.delete( dropped_item )
          @items.push( dropped_item )
        end
      end
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

    def perform( command )
      if command == "take rope"
        if @description.include?( "rope" )
          puts "You take the rope."
          PLAYER.items.push( Rope.new )
          @description = "The linoleum floor shines bleakly in the light."
        else
          super( command )
        end
      else
        super( command )
      end
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

      @towel_taken = false
    end

    def perform( command )
      if command == "take towel"
        unless @towel_taken
          @towel_taken = true
          puts "You take a towel."
          PLAYER.items.push( Towel.new )
        else
          puts "You already have one."
        end
      else
        super( command )
      end
    end
  end

  class BaseballRoom < Room
    def initialize
      super( "The walls are blue here and a baseball hat lies folded on the floor." )
    end

    def perform( command )
      if command == "take baseball hat"
        if @description.include?( "baseball" )
          puts "You take the baseball hat."
          PLAYER.items.push( BaseballHat.new )
          @description = "The walls are blue here."
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class BrainRoom < Room
    def initialize
      super( "Resting on a pedestal is a brain in a jar." )
    end

    def perform( command )
      if command == "take jar"
        if @description.include?( "jar" )
          puts "You take the jar."
          PLAYER.items.push( Jar.new )
          @description = "You see a short, stone pedestal in the middle of the room."
        else
          super( command )
        end
      else
        super( command )
      end
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

    def perform( command )
      if command == "take gem"
        if @description.include?( "gem" )
          puts "You take the gem."
          PLAYER.items.push( Gem.new )
          @description = "You see a short, stone pedestal in the middle of the room."
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class NecklaceRoom < Room
    def initialize
      super( "A small wooden box has been left on the floor." )
      @necklace_taken = false
    end

    def perform( command )
      if command == "take necklace"
        unless @necklace_taken
          @necklace_taken = true
          puts "You take the necklace."
          PLAYER.items.push( Necklace.new )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

end
