require "ducky/player"
require "ducky/terminal_utilities"
require "ducky/translator"
require "ducky/version"
require "ducky/world"

module Ducky
  WORLD = World.new
  PLAYER = Player.new

  class DuckyGame
    include Translator

    def start
      TerminalUtilities.clear
      puts intro

      puts TerminalUtilities.format( WORLD.room_description( PLAYER.location ) )
      loop do
        print "> "
        command = translate( gets.chomp )

        WORLD.room_at( PLAYER.location ).perform( command )

        if command.verb == "quit"
          exit_game
        elsif command.verb == "look"
          puts TerminalUtilities.format( WORLD.room_description( PLAYER.location ) )
        elsif command.verb == "help"
          puts TerminalUtilities.format( "Ducky is a text adventure game. Use commands such as 'go north' and 'take sword' to interact with the world in the game. Once you have explored the rooms and collected any items you think you might need try to figure out how you can use the items together to find the key to the exit. Use the 'look at' command to examine your surroundings and the items you find to get a better idea of what you're working with. For a full list of commands used in this game, type 'commands'. Good luck!" )
        elsif command.verb == "commands"
          puts TerminalUtilities.format( Translator.phrases.join( "\n" ) )
        elsif command.verb == "inventory"
          puts TerminalUtilities.format( "You are carrying:" )
          for item in PLAYER.items
            puts TerminalUtilities.format( "  #{item.name}" )
          end
        end
      end
    end

    def exit_game
      puts TerminalUtilities.format( "Game Over" )
      exit
    end

    private
    # the string that introduces the game
    def intro
      <<~STR
      DUCKY
      --------
      v#{VERSION}
      
      STR
    end

  end
end
