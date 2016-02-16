require "ducky/items"
require "ducky/terminal_utilities"
require "ducky/translator"

module Ducky

  class Room
    include Translator

    attr_reader :description, :items

    def initialize( description )
      @description = description
      @items = []
    end

    def perform( command )
      if command.verb == "take"
        if command.noun == "all"
          until @items.empty?
            puts TerminalUtilities.format( "You take the #{ @items.first.name }." )
            PLAYER.take( @items.shift )
          end
        else
          for item in @items
            if item.identified_by?( command.noun )
              puts TerminalUtilities.format( "You take the #{ command.noun }." )
              taken_item = item
            end
          end

          if taken_item.nil?
            puts TerminalUtilities.format( "You can't take that." )
          else
            @items.delete( taken_item )
            PLAYER.take( taken_item )
          end
        end
      elsif command.verb == "drop"
        if command.noun == "all"
          until PLAYER.items.empty?
            puts TerminalUtilities.format( "You drop the #{ PLAYER.items.first.name }." )
            @items.push( PLAYER.items.shift )
          end
        else 
          for item in PLAYER.items
            if item.identified_by?( command.noun )
              puts TerminalUtilities.format( "You drop the #{ command.noun }." )
              dropped_item = item
            end
          end

          if dropped_item.nil?
            puts TerminalUtilities.format( "You don't have that." )
          else
            PLAYER.items.delete( dropped_item )
            @items.push( dropped_item )
          end
        end
      elsif command.verb == "look at"
        if command.noun == "all"
          for item in PLAYER.items + @items
            puts TerminalUtilities.format( item.description )
          end
        else
          looked = false

          for item in PLAYER.items + @items
            if item.identified_by?( command.noun )
              looked = true
              puts TerminalUtilities.format( item.description )
            end
          end

          unless looked
            puts TerminalUtilities.format( "There is nothing to see." )
          end
        end
      elsif command.verb == "go"
        PLAYER.go( command.noun.to_sym )
      elsif command.verb == "smash"
        if Jar.new.identified_by?( command.noun )
          jar = PLAYER.find_item( "jar" )

          unless jar.nil?
            puts TerminalUtilities.format( "You break the jar. The glass explodes and the fluid goes everywhere." )
            PLAYER.items.delete( jar )
            @items.push( GlassShard.new )
            @items.push( Brain.new )
          end
        end
      end
    end
  end

  class DungeonCellRoom < Room
    def initialize
      super( "You see a white skeleton and a pile of straw." )

      @coin_found = false
      @coin_taken = false
    end

    def perform( command )
      if command.verb == "take"
        if Coin.new.identified_by?( command.noun ) && @coin_found && !@coin_taken
          @coin_taken = true
          puts TerminalUtilities.format( "You take the coin." )
          PLAYER.take( Coin.new )
          return
        elsif command.noun == "skeleton" || command.noun == "bone" || command.noun == "bones"
          puts TerminalUtilities.format( "No." )
          return
        elsif command.noun == "straw"
          puts TerminalUtilities.format( "It's dirty and not really useful. You decide to leave it." )
          return
        end
      elsif command.verb == "look at"
        if command.noun == "skeleton" || command.noun == "bones"
          if @coin_taken
            puts TerminalUtilities.format( "The heap of bones look like the remains of a single person. There is nothing else remarkable about them." )
          else
            puts TerminalUtilities.format( "The heap of bones look like the remains of a single person. You see a shiny coin buried in the bones." )
            @coin_found = true
          end
          return
        elsif command.noun == "straw"
          puts TerminalUtilities.format( "It is rough and looks dirty." )
          return
        elsif Coin.new.identified_by?( command.noun ) && @coin_found && !@coin_taken
          puts TerminalUtilities.format( "A thick gold coin. Possibly a Spanish dubloon." )
          return
        end
      end

      super( command )
    end
  end

  class DungeonRoom < Room
    def initialize
      super( "You see a white skeleton through the bars of a cell to the south." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "skeleton" || command.noun == "bones"
          puts TerminalUtilities.format( "The heap of bones look like the remains of a single person. Unfortunately they are too far behind the bars to get any closer to examine them." )
          return
        elsif command.noun == "straw"
          puts TerminalUtilities.format( "It is rough and looks dirty." )
          return
        end
      end

      super( command )
    end
  end

  class RugRoom < Room
    def initialize
      super( "A thick, red rug strikes a bold difference to the cream-colored walls." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "rug"
          puts TerminalUtilities.format( "It is very soft and a rich red color." )
          return
        end
      end

      super( command )
    end
  end

  class RopeRoom < Room
    def initialize
      super( "A rope is coiled onto the linoleum floor." )
    end

    def perform( command )
      if command.verb == "take"
        if Rope.new.identified_by?( command.noun ) && @description.include?( "rope" )
          puts TerminalUtilities.format( "You take the rope." )
          PLAYER.take( Rope.new )
          @description = "The linoleum floor shines bleakly in the light."
          return
        end
      elsif command.verb == "look at"
        if Rope.new.identified_by?( command.noun ) && @description.include?( "rope" )
          puts TerminalUtilities.format( "It is 10 meters of thick, coarse rope. You imagine it could be used for sailing." )
          return
        end
      end

      super( command )
    end
  end

  class FootStatueRoom < Room
    def initialize
      super( "The only thing in this room is a large, alabaster statue of a foot." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "statue" || command.noun == "foot statue" || command.noun == "foot" || command.noun == "alabaster statue" || command.noun == "alabaster foot" || command.noun == "alabaster foot statue"
          puts TerminalUtilities.format( "With a sole larger than you, this statue is in the shape of a foot cut off at the ankle. The smooth, white surface is shining but on closer inspection you see some small worms crawling near the base." )
          return
        elsif command.noun == "worm" || command.noun == "worms"
          puts TerminalUtilities.format( "A cute, yellow inchworm." )
          return
        end
      elsif command.verb == "take" && command.noun =~ /\Aworms?\Z/
        puts TerminalUtilities.format( "You're not going to touch a possibly deadly worm." )
        return
      end

      super( command )
    end
  end

  class EntranceHall < Room
    def initialize
      super( "You are standing in a room with white walls and a single black door." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "door" || command.noun == "black door"
          puts TerminalUtilities.format( "The door is very dark and very locked. You must find the key to leave." )
          return
        end
      elsif command.verb == "unlock" && command.noun == "door" && PLAYER.find_item( "key" )
        puts TerminalUtilities.format( "You unlock the door. Congratulations, you won!" )
        exit
      end

      super( command )
    end
  end

  class VendingMachineRoom < Room
    def initialize
      super( "The walls of this room are white and a large, purple vending machine stands against one wall." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "vending machine" || command.noun == "purple vending machine"
          puts TerminalUtilities.format( "A fluorescently colored vending machine that only sells one type of soft drink." )
          return
        end
      elsif command.verb == "buy"
        if SoftDrink.new.identified_by?( command.noun )
          coin = PLAYER.find_item( "coin" )

          unless coin.nil?
            puts TerminalUtilities.format( "You put your coin into the machine's slot and select the only type of drink you can buy." )
            PLAYER.items.delete( coin )
            PLAYER.take( SoftDrink.new )
            return
          end
        end
      end

      super( command )
    end
  end

  class TowelRoom < Room
    def initialize
      super( "A stack of fluffy, yellow towels are sitting on a wooden cabinet." )

      @towel_taken = false
    end

    def perform( command )
      if command.verb == "take"
        if Towel.new.identified_by?( command.noun ) || command.noun == "towels" || command.noun == "yellow towels"
          unless @towel_taken
            @towel_taken = true
            puts TerminalUtilities.format( "You take a towel." )
            PLAYER.take( Towel.new )
          else
            puts TerminalUtilities.format( "You already have one." )
          end
          return
        end
      elsif command.verb == "look at"
        if Towel.new.identified_by?( command.noun ) || command.noun == "towels" || command.noun == "yellow towels"
          puts TerminalUtilities.format( "It is a thick, fluffy, yellow towel. Probably super moisture absorbent as well." )
          return
        elsif command.noun == "cabinet" || command.noun == "wooden cabinet"
          puts TerminalUtilities.format( "It is a simple, heavyset cabinet with no drawers or compartments." )
          return
        end
      end

      super( command )
    end
  end

  class BaseballRoom < Room
    def initialize
      super( "The walls are blue here and a baseball hat lies folded on the floor." )
    end

    def perform( command )
      if command.verb == "take"
        if BaseballHat.new.identified_by?( command.noun ) && @description.include?( "baseball" )
          puts TerminalUtilities.format( "You take the baseball hat." )
          PLAYER.take( BaseballHat.new )
          @description = "The walls are blue here."
          return
        end
      elsif command.verb == "look at"
        if BaseballHat.new.identified_by?( command.noun ) && @description.include?( "baseball" )
            puts TerminalUtilities.format( "It is a red, white, and blue baseball hat. It is comfortably flexible. If you had a mirror it would probably look quite nice on you." )
            return
        end
      end

      super( command )
    end
  end

  class BrainRoom < Room
    def initialize
      super( "Resting on a pedestal is a brain in a jar." )
    end

    def perform( command )
      if command.verb == "take"
        if Jar.new.identified_by?( command.noun ) && @description.include?( "jar" )
          puts TerminalUtilities.format( "You take the jar." )
          PLAYER.take( Jar.new )
          @description = "You see a short, stone pedestal in the middle of the room."
          return
        end
      elsif command.verb == "look at"
        if Jar.new.identified_by?( command.noun ) && @description.include?( "jar" )
            puts TerminalUtilities.format( "It is a large, clear, glass jar with a metal lid. Inside floating in some clear liquid is a squishy-looking brain." )
            return
        elsif command.noun == "pedestal"
          puts TerminalUtilities.format( "A short pedestal made of white stone. It is perfect for holding up an object like a glass jar." )
        end
      end

      super( command )
    end
  end

  class HoleRoom < Room
    def initialize
      super( "There is a large hole in the wooden floor of this room." )

      @rope_tied = false
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "hole" || command.noun == "large hole"
          puts TerminalUtilities.format( "It is large and dark. You can see straw below you." )
          return
        end
      elsif command.verb == "climb down" && command.noun == "hole"
        if command.object
          if Rope.new.identified_by?( command.object )
            if @rope_tied
              command = translate( "go down" )
            else
              rope = PLAYER.find_item( "rope" )

              unless rope.nil?
                @rope_tied = true
                PLAYER.items.delete( rope )
                @description = "There is a large hole in the wooden floor of this room. The rope you tied to the door leads down into the cell."
                WORLD.stairs[ Coordinate.new(2, 1, 0) ] = [ :down ]
                WORLD.stairs[ Coordinate.new(2, 1, -1) ] = [ :up ]
                puts TerminalUtilities.format( "You tie the rope to the door and climb down into the darkness." )
                command = translate( "go down" )
              end
            end
          end
        else
          if @rope_tied
            command = translate( "go down" )
          else
            puts TerminalUtilities.format( "With what?" )
            return
          end
        end
      end

      super( command )
    end
  end

  class DungeonStairsRoom < Room
    def initialize
      super( "The walls and floor of this room are stone and a narrow stone staircase leads down." )
    end

    def perform( command )
      if command.verb == "look at"
        if command.noun == "staircase" || command.noun = "stairs" || command.noun == "stone staircase"
          puts TerminalUtilities.format( "They are stone stairs. They lead down." )
          return
        end
      end

      super( command )
    end
  end

  class GemRoom < Room
    def initialize
      super( "There is a gem on a pedestal here." )
    end

    def perform( command )
      if command.verb == "take"
        if Gem.new.identified_by?( command.noun ) && @description.include?( "gem" )
          puts TerminalUtilities.format( "You take the gem." )
          PLAYER.take( Gem.new )
          @description = "You see a short, stone pedestal in the middle of the room."
          return
        end
      elsif command.verb == "look at"
        if Gem.new.identified_by?( command.noun )
          if @description.include?( "gem" )
            puts TerminalUtilities.format( "It is about the size of your thumb but it sparkles brilliantly in the light." )
            return
          end
        elsif command.noun == "pedestal"
          puts TerminalUtilities.format( "A short pedestal made of white stone. It is perfect for holding up an object like a gem." )
          comand = ""
        end
      end

      super( command )
    end
  end

  class NecklaceRoom < Room
    def initialize
      super( "A small wooden box has been left on the floor." )
      @necklace_found = false
      @necklace_taken = false
    end

    def perform( command )
      if command.verb == "take"
        if Necklace.new.identified_by?( command.noun ) && @necklace_found && !@necklace_taken
          @necklace_taken = true
          puts TerminalUtilities.format( "You take the necklace." )
          PLAYER.take( Necklace.new )
          return
        end
      elsif command.verb == "take" && ( command.noun == "box" || command.noun == "wooden box" )
        puts TerminalUtilities.format( "You can't take that, it's attached to the floor." )
        return
      elsif command.verb == "look at"
        if command.noun == "box" || command.noun == "wooden box"
          if @necklace_taken
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see that it is empty." )
          else
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see a silver necklace." )
            @necklace_found = true
          end
          return
        elsif Necklace.new.identified_by?( command.noun ) && @necklace_found && !@necklace_taken
          puts TerminalUtilities.format( "A fragile, silver necklace with a silver lion pendant." )
          return
        end
      elsif command.verb == "look in"
        if command.noun == "box" || command.noun == "wooden box"
          if @necklace_taken
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see that it is empty." )
          else
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see a silver necklace." )
            @necklace_found = true
          end
          return
        end
      end

      super( command )
    end
  end

end
