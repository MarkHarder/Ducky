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
          puts TerminalUtilities.format( "Ducky is a text adventure game. Use commands such as 'go north' and 'take sword' to interact with the world in the game. Once you have explored the rooms and collected any items you think you might need try to figure out how you can use the items together to find the key to the exit. Use the 'look at' command to examine your surroundings and the items you find to get a better idea of what you're working with. For a full list of commands used in this game, type 'commands'. Good luck!" )
        elsif command == "commands"
          puts TerminalUtilities.format( "take [noun]\ndrop [noun]\ngo [direction]\nlook at [noun]\nsmash [noun]\nbuy [noun]\nclimb down [noun] with [noun]\nunlock [noun]" )
        elsif command == "inventory"
          puts "You are carrying:"
          for item in PLAYER.items
            puts "  #{item.name}"
          end
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
        "x" => "look at",
      }

      synonyms = {
        "break" => "smash",
        "destroy" => "smash",
        "examine" => "look at",
        "get" => "take",
        "open" => "unlock",
        "purchase" => "buy",
        "walk" => "go",
      }

      # remove non-word, non-whitespace, non-number characters
      text.gsub!( /[^[:word:]\s\d]/, "" )

      # make the text lowercase and split it on whitespace
      words = text.downcase.split( /\s+/ )

      words.collect! do |word|
        if abbreviations.keys.include?( word )
          abbreviations[ word ]
        elsif synonyms.keys.include?( word )
          synonyms[ word ]
        else
          word
        end
      end

      translation = words.join( " " )

      translation.gsub!( "pick up", "take" )
      translation.gsub!( "climb into", "climb down" )
      translation.gsub!( "put down", "drop" )
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
