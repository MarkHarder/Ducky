require "ducky/player"
require "ducky/terminal_utilities"
require "ducky/version"
require "ducky/world"

module Ducky
  WORLD = World.new
  PLAYER = Player.new

  class DuckyGame
    def start
      TerminalUtilities.clear
      puts intro

      WORLD.describe_room( PLAYER.location )
      loop do
        print "> "
        command = translate( gets.chomp )

        WORLD.room_at( PLAYER.location ).perform( command )

        if command == "quit"
          exit_game
        elsif command == "look"
          WORLD.describe_room( PLAYER.location )
        elsif command == "help"
          puts TerminalUtilities.format( "Ducky is a text adventure game. Use commands such as 'go north' and 'take sword' to interact with the world in the game. Once you have explored the rooms and collected any items you think you might need try to figure out how you can use the items together to find the key to the exit. For a full list of commands used in this game, type 'commands'. If you are stuck, type 'hint'. Good luck!" )
        elsif command == "inventory"
          puts "You are carrying:"
          for item in PLAYER.items
            puts "  #{item.name}"
          end
        elsif command.start_with?( "go" )
          direction = command.split( /\s/ ).last.to_sym
          PLAYER.go( direction )
        end
      end
    end

    def exit_game
      puts "Game Over"
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

    # translate input into game-usable commands
    def translate( text )
      abbreviations = {
        "q" => "quit",
        "n" => "north",
        "s" => "south",
        "e" => "east",
        "w" => "west",
        "u" => "up",
        "d" => "down",
        "i" => "inventory",
      }

      words = text.split( /\s+/ )

      words.collect! do |word|
        if abbreviations.keys.include?( word )
          abbreviations[ word ]
        else
          word
        end
      end

      translation = words.join( " " )

      translation = "go north" if translation == "north"
      translation = "go south" if translation == "south"
      translation = "go east" if translation == "east"
      translation = "go west" if translation == "west"
      translation = "go up" if translation == "up"
      translation = "go down" if translation == "down"

      if translation.start_with?( "go" )
        possible_directions = ["north", "south", "west", "east", "up", "down"]
        possible_commands = possible_directions.collect { |d| "go #{d}" }

        unless possible_commands.include?( translation )
          puts "You must enter a valid direction to go."
          translation = ""
        end
      end

      translation
    end
  end
end
