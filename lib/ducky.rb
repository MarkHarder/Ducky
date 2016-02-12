require "ducky/player"
require "ducky/version"
require "ducky/world"

module Ducky
  WORLD = World.new
  PLAYER = Player.new

  class DuckyGame
    def start
      clear
      puts intro

      puts WORLD.room_at( PLAYER.location ).description
      loop do
        print "> "
        command = translate( gets.chomp )

        WORLD.room_at( PLAYER.location ).perform( command )

        if command == "quit"
          exit_game
        elsif command == "look"
          puts WORLD.room_at( PLAYER.location ).description
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

    # clear the terminal
    def clear
      # ASCII escape sequences
      print "\e[2J\e[24H"
    end

    # translate input into game-usable commands
    def translate( text )
      abbreviations = {
        "q" => "quit",
        "n" => "north",
        "s" => "south",
        "e" => "east",
        "w" => "west",
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
